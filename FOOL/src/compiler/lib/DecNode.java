package compiler.lib;

public abstract class DecNode extends Node {
	
	protected TypeNode type;
		
	public TypeNode getType() {
        if (type == null) {
            throw new RuntimeException("Type not set for DecNode at line " + getLine());
        }
        return type;
    }

}
