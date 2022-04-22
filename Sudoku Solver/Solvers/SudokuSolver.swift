import Foundation
import Algorithms

public enum SolverError: Error {
	case unsolvableSudoku
}

public class SudokuSolver {
	static let blocks = [[Int](0...2), [Int](3...5), [Int](6...8)]
	static let values = [Int](1...9)

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

	func consistent(_ sudoku: Sudoku) -> Bool {
		for i in 0 ..< sudoku.count {
			if !validRow(sudoku: sudoku, row: i) || !validCol(sudoku: sudoku, col: i) {
				return false
			}
		}

		for pos in getGridsStartPositions(SudokuSolver.blocks) {
			if !validSubGrid(sudoku: sudoku, subgrids: SudokuSolver.blocks, row: pos.row, col: pos.column) {
				return false
			}
		}

		return true
	}

	func validRow(sudoku: Sudoku, row: Int) -> Bool {
		return freeInRow(sudoku: sudoku, row: row).isEmpty
	}

	func validCol(sudoku: Sudoku, col: Int) -> Bool {
		return freeInCol(sudoku: sudoku, col: col).isEmpty
	}

	func validSubGrid(sudoku: Sudoku, subgrids: [[Int]], row: Int, col: Int) -> Bool {
		return freeInSubGrid(sudoku: sudoku, subgrids: subgrids, row: row, col: col).isEmpty
	}

	func freeInRow(sudoku: Sudoku, row: Int) -> [Int] {
		return freeIn(sudoku.getRow(row))
	}

	func freeInCol(sudoku: Sudoku, col: Int) -> [Int] {
		return freeIn(sudoku.getCol(col))
	}

	func freeInSubGrid(sudoku: Sudoku, subgrids: [[Int]], row: Int, col: Int) -> [Int] {
		return freeIn(sudoku.getGrid(blocks: subgrids, row: row, col: col))
	}

	func freeAtPosition(sudoku: Sudoku, row: Int, col: Int) -> [Int] {
		let freeInRow = Set(freeInRow(sudoku: sudoku, row: row))
		let freeInCol = Set(freeInCol(sudoku: sudoku, col: col))
		let freeInSubGrid = Set(freeInSubGrid(sudoku: sudoku, subgrids: SudokuSolver.blocks, row: row, col: col))

		return Array(freeInRow.intersection(freeInCol)
			.intersection(freeInSubGrid))
	}

	func getGridsStartPositions(_ blocks: [[Int]]) -> [Position] {
		return product(blocks, blocks).map { rows, cols in
			Position(rows[0], cols[0])
		}
	}

	func freeIn(_ sequence: [Int?]) -> [Int] {
		if sequence.isEmpty {
			return SudokuSolver.values
		}

		let nSet = Set(SudokuSolver.values)
		let sequenceSet = Set(sequence.compacted())

		return Array(nSet.subtracting(sequenceSet)).sorted()
	}
}
