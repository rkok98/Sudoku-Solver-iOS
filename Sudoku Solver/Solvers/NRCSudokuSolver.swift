import Algorithms

public class NRCSudokuSolver: SudokuSolver {
	let NRCBlocks = [[1 ... 3], [5 ... 8]]

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
		for pos in sudoku.getGridsStartPositions(NRCSudoku.blocks) {
			if !validSubGrid(sudoku: sudoku, subgrids: NRCSudoku.blocks, row: pos.row, col: pos.column) {
				return false
			}
		}

		// Validate NRC-grids
		for pos in sudoku.getGridsStartPositions(NRCSudoku.nrcBlocks) {
			if !validSubGrid(sudoku: sudoku, subgrids: NRCSudoku.nrcBlocks, row: pos.row, col: pos.column) {
				return false
			}
		}

		return true
	}

	override func freeAtPosition(sudoku: Sudoku, row: Int, col: Int) -> [Int] {
		let freeInRow = Set(self.freeInRow(sudoku: sudoku, row: row))
		let freeInCol = Set(self.freeInCol(sudoku: sudoku, col: col))
		let freeInSubGrid = Set(self.freeInSubGrid(sudoku: sudoku, subgrids: NRCSudoku.blocks, row: row, col: col))

		if sudoku.getGrid(blocks: NRCSudoku.nrcBlocks, row: row, col: col).isEmpty {
			return Array(freeInRow
				.intersection(freeInCol)
				.intersection(freeInSubGrid)
			)
		}

		let freeInNRCGrid = Set(self.freeInSubGrid(sudoku: sudoku, subgrids: NRCSudoku.nrcBlocks, row: row, col: col))

		return Array(freeInRow
			.intersection(freeInCol)
			.intersection(freeInSubGrid)
			.intersection(freeInNRCGrid)
		)
	}
}
