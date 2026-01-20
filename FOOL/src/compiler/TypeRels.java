package compiler;

import compiler.AST.*;
import compiler.lib.*;

import java.util.HashMap;
import java.util.Map;

public class TypeRels {
    public static Map<String, String> superType = new HashMap<>();

	public static boolean isSubtype(TypeNode a, TypeNode b) {

        if (a == null || b == null) {
            return false;
        }

        if (a instanceof EmptyTypeNode && b instanceof RefTypeNode) {
            return true;
        }

        if (a instanceof RefTypeNode oa && b instanceof RefTypeNode ob) {
            if (oa.id.equals(ob.id)) {
                return true;
            }
            return isSubtype(superType(oa.id), ob);
        }

        if (a instanceof ArrowTypeNode atA && b instanceof ArrowTypeNode atB) {

            if (!isSubtype(atA.ret, atB.ret)) {     // covarianza
                return false;
            }

            if (atA.parlist.size() != atB.parlist.size()) {
                return false;
            }
            for (int i = 0; i < atA.parlist.size(); i++) {
                if (!isSubtype(atB.parlist.get(i), atA.parlist.get(i))) {   // controvarianza
                    return false;
                }
            }
            return true;
        }

		return a.getClass().equals(b.getClass()) || ((a instanceof BoolTypeNode) && (b instanceof IntTypeNode));
	}

    public static TypeNode lowestCommonAncestor(TypeNode a, TypeNode b) {
        if (isSubtype(a, b)) {
            return b;
        } else if (b instanceof RefTypeNode ob) {   // controlla anche che b non sia null
            return lowestCommonAncestor(a, superType(ob.id));
        } else if (isSubtype(b, a)) {   // nel caso b int, bool o EmptyTypeNode
            return a;
        }
        return null;
    }

    private static RefTypeNode superType(String typeId) {
        String superTypeId = superType.get(typeId);
        if (superTypeId != null) {
            return new RefTypeNode(superTypeId);
        } else {
            return null;
        }
    }
}
