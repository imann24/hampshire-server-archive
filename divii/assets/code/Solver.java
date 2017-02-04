package imann.puzzlefactory.puzzles.components;

public class Solver {
	Puzzle p;
	String [] posValues;
	public Solver(Puzzle p) {
		this.p = p;
		posValues = new String [p.getPossibleValues().length];
		System.arraycopy(p.getPossibleValues(), 0, posValues, 0, p.getPossibleValues().length);
	}
	
	public boolean label (Spot[][] spots, int row, int column) {
		boolean labeled = false;
		if (row==p.getRows()) {
			return p.constraintsSatisfied();
		}
		//spots[column][row].getValue().charAt(1) != ' '
		if (!p.isDefaultValue(spots[column][row].getValue())) {
			labeled = true;
		}
		for (String s : posValues) {
			if (!labeled)
				spots[column][row].setValue(s);
			if (p.constraintsSatisfied() || p.isStaticValue(spots[row][column].getValue())) {
				int newColumn = column+1;
				int newRow = row;
				if (newColumn == p.getColumns()) {
					newColumn = 0;
					newRow = row+1;
				}
				if (label(spots, newRow, newColumn)) {
					return true;
				}
			}
		}
		if(!p.hasStaticValues() || !p.isStaticValue(spots[row][column].getValue()))
			spots[column][row].setValue(p.defaultValue(column, row));
		return false;
	}

}
