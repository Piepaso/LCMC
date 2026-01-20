package compiler;

import java.util.*;
import compiler.AST.*;
import compiler.exc.*;
import compiler.lib.*;

public class SymbolTableASTVisitor extends BaseASTVisitor<Void,VoidException> {
	
	private final List<Map<String, STentry>> symTable = new ArrayList<>();
    private final Map<String, Map<String, STentry>> classTable = new HashMap<>();
	private int nestingLevel=0; // current nesting level
	private int decOffset=-2; // counter for offset of local declarations at current nesting level 
	int stErrors=0;

	SymbolTableASTVisitor() {}
	SymbolTableASTVisitor(boolean debug) {super(debug);} // enables print for debugging

	private STentry stLookup(String id) {
		int j = nestingLevel;
		STentry entry = null;
		while (j >= 0 && entry == null) 
			entry = symTable.get(j--).get(id);	
		return entry;
	}

	@Override
	public Void visitNode(ProgLetInNode n) {
		if (print) printNode(n);
		Map<String, STentry> hm = new HashMap<>();
		symTable.add(hm);
	    for (Node dec : n.declist) visit(dec);
		visit(n.exp);
		symTable.removeFirst();
		return null;
	}

	@Override
	public Void visitNode(ProgNode n) {
		if (print) printNode(n);
		visit(n.exp);
		return null;
	}
	
	@Override
	public Void visitNode(FunNode n) {
		if (print) printNode(n);
		Map<String, STentry> hm = symTable.get(nestingLevel);
		STentry entry = new STentry(nestingLevel, n.getType() ,decOffset--);
		//inserimento di ID nella symtable
		if (hm.put(n.id, entry) != null) {
			System.out.println("Fun id " + n.id + " at line "+ n.getLine() +" already declared");
			stErrors++;
		} 
		//creare una nuova hashmap per la symTable
		nestingLevel++;
		Map<String, STentry> hmn = new HashMap<>();
		symTable.add(hmn);
		int prevNLDecOffset=decOffset; // stores counter for offset of declarations at previous nesting level 
		decOffset=-2;
		
		int parOffset=1;
		for (ParNode par : n.parlist)
			if (hmn.put(par.id, new STentry(nestingLevel,par.getType(),parOffset++)) != null) {
				System.out.println("Par id " + par.id + " at line "+ n.getLine() +" already declared");
				stErrors++;
			}
		for (Node dec : n.declist) visit(dec);
		visit(n.exp);
		//rimuovere la hashmap corrente poiche' esco dallo scope               
		symTable.remove(nestingLevel--);
		decOffset=prevNLDecOffset; // restores counter for offset of declarations at previous nesting level 
		return null;
	}

    @Override
    public Void visitNode(VarNode n) {
        if (print) printNode(n);
        visit(n.exp);
        Map<String, STentry> hm = symTable.get(nestingLevel);
        STentry entry = new STentry(nestingLevel,n.getType(),decOffset--);
        //inserimento di ID nella symtable
        if (hm.put(n.id, entry) != null) {
            System.out.println("Var id " + n.id + " at line "+ n.getLine() +" already declared");
            stErrors++;
        }
        return null;
    }

    @Override
    public Void visitNode(ClassNode n) {
        if (print) printNode(n);
        Map<String, STentry> hm = symTable.get(nestingLevel);
        Map<String, STentry> vt = new HashMap<>();
        List<TypeNode> fieldTypes = new ArrayList<>();
        List<ArrowTypeNode> methodTypes = new ArrayList<>();
        HashSet<String> declared = new HashSet<>();
        int offset;

        n.superEntry = symTable.getFirst().get(n.superId);

        if (hm.containsKey(n.id)) {
            System.out.println("Class id " + n.id + " at line " + n.getLine() + " already declared");
            stErrors++;
        }

        if (n.superId != null) {
            if (hm.containsKey(n.superId)) {
                ClassTypeNode superType = (ClassTypeNode) hm.get(n.superId).type;
                vt.putAll(classTable.get(n.superId));
                fieldTypes.addAll(superType.allFields);
                methodTypes.addAll(superType.allMethods);
            } else {
                System.out.println("Class id " + n.superId + " at line "+ n.getLine() + " not declared");
                stErrors++;
            }
        }

        offset = vt.values().stream().mapToInt(ste -> ste.offset).filter(o -> o < 0).min().orElse(0) - 1;
        for (FieldNode field : n.fields) {
            if (declared.contains(field.id)) {     // ottimizzazione check multiple dichiarazioni
                System.out.println("Field id " + field.id + " at line "+ field.getLine() +" already declared");
                stErrors++;
                continue;
            }

            int o;
            if (vt.containsKey(field.id)) {
                o = vt.get(field.id).offset;
                if (o > -1) {
                    System.out.println("Field id " + field.id + " at line "+ field.getLine() +" already declared as method in superclass");
                    stErrors++;
                    continue;
                }
            } else {
                o = offset--;
                fieldTypes.add(field.getType());     // aggiungo un nuovo type solo se non è override
            }

            vt.put(field.id, new STentry(nestingLevel+1, field.getType(), o));
            field.offset = o;
            declared.add(field.id);
        }

        offset = vt.values().stream().mapToInt(ste -> ste.offset).filter(o -> o >= 0).max().orElse(-1) + 1;
        for (MethodNode method : n.methods) {
            if (declared.contains(method.id)) {     // ottimizzazione check multiple dichiarazioni
                System.out.println("Method id " + method.id + " at line "+ method.getLine() +" already declared");
                stErrors++;
                continue;
            }

            int o;
            if (vt.containsKey(method.id)) {
                o = vt.get(method.id).offset;
                if (o < 0) {
                    System.out.println("Method id " + method.id + " at line "+ method.getLine() +" already declared as field in superclass");
                    stErrors++;
                    continue;
                }
            } else {
                o = offset++;
                methodTypes.add((ArrowTypeNode) method.getType());     // aggiungo un nuovo type solo se non è override
            }

            vt.put(method.id, new STentry(nestingLevel+1, method.getType(),o));
            method.offset = o;
            declared.add(method.id);
        }

        var classType = new ClassTypeNode(fieldTypes, methodTypes);
        n.setType(classType);

        STentry entry = new STentry(nestingLevel, classType, decOffset--);
        hm.put(n.id, entry);
        classTable.put(n.id, vt);
        symTable.add(vt);
        nestingLevel++;

        for (MethodNode method : n.methods) { visit(method);}

        symTable.remove(nestingLevel--);      // restores counter for offset of declarations at previous nesting level

        return null;
    }

    @Override
    public Void visitNode(MethodNode n) {
        if (print) printNode(n);
        nestingLevel++;
        Map<String, STentry> hmn = new HashMap<>();
        symTable.add(hmn);
        int prevNLDecOffset=decOffset; // stores counter for offset of declarations at previous nesting level
        decOffset=-2;

        int parOffset=1;
        for (ParNode par : n.parlist)
            if (hmn.put(par.id, new STentry(nestingLevel,par.getType(),parOffset++)) != null) {
                System.out.println("Par id " + par.id + " at line "+ n.getLine() +" already declared");
                stErrors++;
            }
        for (Node dec : n.declist) visit(dec);
        visit(n.exp);
        //rimuovere la hashmap corrente poiche' esco dallo scope
        symTable.remove(nestingLevel--);
        decOffset=prevNLDecOffset; // restores counter for offset of declarations at previous nesting level
        return null;
    }

	@Override
	public Void visitNode(PrintNode n) {
		if (print) printNode(n);
		visit(n.exp);
		return null;
	}

	@Override
	public Void visitNode(IfNode n) {
		if (print) printNode(n);
		visit(n.cond);
		visit(n.th);
		visit(n.el);
		return null;
	}
	
	@Override
	public Void visitNode(EqualNode n) {
		if (print) printNode(n);
		visit(n.left);
		visit(n.right);
		return null;
	}

    @Override
    public Void visitNode(GreaterEqualNode n) {
        if (print) printNode(n);
        visit(n.left);
        visit(n.right);
        return null;
    }

    @Override
    public Void visitNode(LessEqualNode n) {
        if (print) printNode(n);
        visit(n.left);
        visit(n.right);
        return null;
    }

    @Override
    public Void visitNode(AndNode n) {
        if (print) printNode(n);
        visit(n.left);
        visit(n.right);
        return null;
    }

    @Override
    public Void visitNode(OrNode n) {
        if (print) printNode(n);
        visit(n.left);
        visit(n.right);
        return null;
    }

    @Override
    public Void visitNode(NotNode n) {
        if (print) printNode(n);
        visit(n.exp);
        return null;
    }
	
	@Override
	public Void visitNode(TimesNode n) {
		if (print) printNode(n);
		visit(n.left);
		visit(n.right);
		return null;
	}

    @ Override
    public Void visitNode(DivNode n) {
        if (print) printNode(n);
        visit(n.left);
        visit(n.right);
        return null;
    }
	
	@Override
	public Void visitNode(PlusNode n) {
		if (print) printNode(n);
		visit(n.left);
		visit(n.right);
		return null;
	}

    @Override
    public Void visitNode(MinusNode n) {
        if (print) printNode(n);
        visit(n.left);
        visit(n.right);
        return null;
    }

	@Override
	public Void visitNode(CallNode n) {
		if (print) printNode(n);
		STentry entry = stLookup(n.id);
		if (entry == null) {
			System.out.println("Fun id " + n.id + " at line "+ n.getLine() + " not declared");
			stErrors++;
		} else {
			n.entry = entry;
			n.nl = nestingLevel;
		}
		for (Node arg : n.arglist) visit(arg);
		return null;
	}

    @Override
    public Void visitNode(ClassCallNode n) {
        if (print) printNode(n);
        STentry objEntry = stLookup(n.objId);
        if (objEntry == null) {
            System.out.println("id " + n.objId + " at line "+ n.getLine() + " not declared");
            stErrors++;
        } else if (!(objEntry.type instanceof RefTypeNode refType)) {
            System.out.println("id " + n.objId + " at line "+ n.getLine() + " is not of class type");
            stErrors++;
        } else {
            n.classEntry = objEntry;
            Map<String, STentry> vt = classTable.get(refType.id);
            if (vt == null || !vt.containsKey(n.methodId)) {
                System.out.println("Method id " + n.methodId + " at line "+ n.getLine() + " not declared in class " + refType.id);
                stErrors++;
            } else {
                n.methodEntry = vt.get(n.methodId);
				n.nl = nestingLevel;
            }
        }
        for (Node arg : n.arglist) visit(arg);
        return null;
    }

    @Override
    public Void visitNode(NewNode n) {
        if (print) printNode(n);
        if (!classTable.containsKey(n.id)) {
            System.out.println("Class id " + n.id + " at line "+ n.getLine() + " not declared");
            stErrors++;
        }
        n.entry = symTable.getFirst().get(n.id);
        n.nl = nestingLevel;
        for (Node arg : n.arglist) visit(arg);
        return null;
    }

    @Override
    public Void visitNode(EmptyNode n) {
        if (print) printNode(n);
        return null;
    }

	@Override
	public Void visitNode(IdNode n) {
		if (print) printNode(n);
		STentry entry = stLookup(n.id);
		if (entry == null) {
			System.out.println("Var or Par id " + n.id + " at line "+ n.getLine() + " not declared");
			stErrors++;
		} else {
			n.entry = entry;
			n.nl = nestingLevel;
		}
		return null;
	}

	@Override
	public Void visitNode(BoolNode n) {
		if (print) printNode(n, n.val.toString());
		return null;
	}

	@Override
	public Void visitNode(IntNode n) {
		if (print) printNode(n, n.val.toString());
		return null;
	}
}
