import Foundation
import Algorithms

public enum SolverError: Error {
	case unsolvableSudoku
}

public class SudokuSolver {
	static let subGrids = [[Int](0...2), [Int](3...5), [Int](6...8)]
	static let values = [Int](1...9)

	/**
	 Solves the given sudoku.
	 */
	public func solve(_ sudoku: Sudoku) throws -> Sudoku {
		var stack: [Sudoku] = []

		stack.append(sudoku)

		while !stack.isEmpty {
			let sud = stack.popLast()

			if let sud = sud {
				if consistent(sud) {
					return sud
				}

				let cons = constraints(sud)
				if !cons.isEmpty {
					let constraint = cons[0]

					for value in constraint.values {
						var s = sud

						s = s.extend(row: constraint.position.row,
						             column: constraint.position.column,
						             value: value)

						stack.append(s)
					}
				}
			}
		}

		throw SolverError.unsolvableSudoku
	}

	/**
	 Calculates all possible values for every cell in the sudoku
	 sorted by amount of possible values.
	 */
	func constraints(_ sudoku: Sudoku) -> [Constraint] {
		return sudoku.getOpenPositions().map { pos -> Constraint in
			Constraint(position: pos,
			           values: freeAtPosition(sudoku: sudoku,
			                                  row: pos.row,
			                                  col: pos.column))
		}.sorted(by: {
			$0.values.count < $1.values.count
		})
	}

	/**
	 Validates if the sudoku is completed and valid.
	 */
	func consistent(_ sudoku: Sudoku) -> Bool {
		// Validate rows and columns
		for i in 0 ..< sudoku.count {
			if !validRow(sudoku: sudoku, row: i) || !validCol(sudoku: sudoku, col: i) {
				return false
			}
		}

		// Validates sub-grids
		for pos in getGridsStartPositions(SudokuSolver.subGrids) {
			if !validSubGrid(sudoku: sudoku, subgrids: SudokuSolver.subGrids, row: pos.row, col: pos.column) {
				return false
			}
		}

		return true
	}

	/**
	 Checks if the given row in a sudoku is valid.
	 */
	func validRow(sudoku: Sudoku, row: Int) -> Bool {
		return freeInRow(sudoku: sudoku, row: row).isEmpty
	}

	/**
	 Checks if the given col in a sudoku is valid.
	 */
	func validCol(sudoku: Sudoku, col: Int) -> Bool {
		return freeInCol(sudoku: sudoku, col: col).isEmpty
	}

	/**
	 Checks if the given sub-grid in a sudoku is valid.
	 */
	func validSubGrid(sudoku: Sudoku, subgrids: [[Int]], row: Int, col: Int) -> Bool {
		return freeInSubGrid(sudoku: sudoku, subgrids: subgrids, row: row, col: col).isEmpty
	}

	/**
	 Calculates the free possible values for a row.
	 */
	func freeInRow(sudoku: Sudoku, row: Int) -> [Int] {
		return freeIn(sudoku.getRow(row))
	}

	/**
	 Calculates the free possible values for a col.
	 */
	func freeInCol(sudoku: Sudoku, col: Int) -> [Int] {
		return freeIn(sudoku.getCol(col))
	}

	/**
	 Calculates the free possible values for a sub-grid.
	 */
	func freeInSubGrid(sudoku: Sudoku, subgrids: [[Int]], row: Int, col: Int) -> [Int] {
		return freeIn(sudoku.getGrid(blocks: subgrids, row: row, col: col))
	}

	/**
	 Calculates the free possible values for a position.
	 */
	func freeAtPosition(sudoku: Sudoku, row: Int, col: Int) -> [Int] {
		let freeInRow = Set(freeInRow(sudoku: sudoku, row: row))
		let freeInCol = Set(freeInCol(sudoku: sudoku, col: col))
		let freeInSubGrid = Set(freeInSubGrid(sudoku: sudoku, subgrids: SudokuSolver.subGrids, row: row, col: col))

		return Array(freeInRow.intersection(freeInCol)
			.intersection(freeInSubGrid))
	}

	/**
	 Calculates the start positions of the given blocks.
	 */
	func getGridsStartPositions(_ blocks: [[Int]]) -> [Position] {
		return product(blocks, blocks).map { rows, cols in
			Position(rows[0], cols[0])
		}
	}

	/**
	 Calculates the free possible values in a sequence of integers.
	 */
	func freeIn(_ sequence: [Int?]) -> [Int] {
		if sequence.isEmpty {
			return SudokuSolver.values
		}

		let nSet = Set(SudokuSolver.values)
		let sequenceSet = Set(sequence.compacted())

		return Array(nSet.subtracting(sequenceSet)).sorted()
	}
}
