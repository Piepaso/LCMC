package compiler.lib;

import compiler.AST.*;

public class BaseASTVisitor<S>{

	public S visit(Node n) {
		return n.accept(this);
	}
	
	public S visitNode(ProgNode n) { throw new UnimplException(); }
	public S visitNode(PlusNode n) { throw new UnimplException(); }
	public S visitNode(TimesNode n) { throw new UnimplException(); }
	public S visitNode(IntNode n) { throw new UnimplException(); }
}





//	protected boolean print=false;
//	protected BaseASTVisitor() {}
//	protected BaseASTVisitor(boolean p) { print=p; }

