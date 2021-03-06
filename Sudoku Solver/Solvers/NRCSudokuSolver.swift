import Algorithms

public class NRCSudokuSolver: SudokuSolver {
	static let nrcGrids = [[Int](1...3), [Int](5...7)]

	override func consistent(_ sudoku: Sudoku) -> Bool {
		if !sudoku.getOpenPositions().isEmpty {
			return false
		}

		// Validate rows and cols
		for i in 0 ..< sudoku.count {
			if !validRow(sudoku: sudoku, row: i) || !validCol(sudoku: sudoku, col: i) {
				return false
			}
		}

		// Validate sub-grids
		for pos in getGridsStartPositions(NRCSudokuSolver.subGrids) {
			if !validSubGrid(sudoku: sudoku, subgrids: NRCSudokuSolver.subGrids, row: pos.row, col: pos.column) {
				return false
			}
		}

		// Validate NRC-grids
		for pos in getGridsStartPositions(NRCSudokuSolver.nrcGrids) {
			if !validSubGrid(sudoku: sudoku, subgrids: NRCSudokuSolver.nrcGrids, row: pos.row, col: pos.column) {
				return false
			}
		}

		return true
	}

	override func freeAtPosition(sudoku: Sudoku, row: Int, col: Int) -> [Int] {
		let freeInRow = Set(self.freeInRow(sudoku: sudoku, row: row))
		let freeInCol = Set(self.freeInCol(sudoku: sudoku, col: col))
		let freeInSubGrid = Set(self.freeInSubGrid(sudoku: sudoku, subgrids: NRCSudokuSolver.subGrids, row: row, col: col))
		let freeInNRCGrid = Set(self.freeInSubGrid(sudoku: sudoku, subgrids: NRCSudokuSolver.nrcGrids, row: row, col: col))

		return Array(freeInRow
			.intersection(freeInCol)
			.intersection(freeInSubGrid)
			.intersection(freeInNRCGrid)
		)
	}
}
