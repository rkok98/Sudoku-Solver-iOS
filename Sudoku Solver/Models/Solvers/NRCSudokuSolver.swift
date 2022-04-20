import Foundation

public class NRCSudokuSolver : SudokuSolver {
	override public func consistent(_ sudoku: Sudoku) -> Bool {
		return true
	}

	override public func freeAtPosition(sudoku: Sudoku, row: Int, col: Int) -> [Int] {
		return []
	}

	public func freeInNRCGrid(sudoku: Sudoku, row: Int, col: Int) -> [Int] {
		return []
	}
}

extension Sudoku {
	let NRCBlocks = [[2...4], [4...8]]

	/**
	 - Parameters:
	 - row: The index of a row in the sudoku.
	 - col: The index of a column in the sudoku.

	 - Returns:
	 an array of the values inside the specified column
	 */
	func getNRCGrid(row: Int, col: Int) -> NRCGrid {
		let sqrt = sqrt(self.count)
		let block = (row / sqrt) * sqrt + (col / sqrt)

		return self.getSubGrids()[block]
	}

	public func getNRCGrids() -> [NRCGrid] {
		let sqrt = sqrt(self.count)
		var grids = [NRCGrid](repeating: [], count: self.count)

		for (rowIndex, row) in self.enumerated() {
			for (colIndex, col) in row.enumerated() {
				let block: Int = (rowIndex / sqrt) * sqrt + (colIndex / sqrt)
				grids[block].append(col)
			}
		}

		return grids
	}

	func getNRCGridsStartPosition() -> [Position] {
		let sqrt = sqrt(self.count)
		var positions = stride(from: 0, to: self.count, by: sqrt).compactMap { $0 }

		positions.append(contentsOf: positions)

		return positions.uniquePermutations(ofCount: 2).map { Position($0[0], $0[1]) }
	}
}
