import Foundation

public class SudokuSolver {
	public func solve(_ sudoku: Sudoku, amountOfSolutions: Int = 1) -> [Sudoku] {
		var stack: [Sudoku] = []
		var solutions: [Sudoku] = []

		stack.append(sudoku)

		while !stack.isEmpty {
			let sud = stack.popLast()

			if let sud = sud {
				if consistent(sud) {
					solutions.append(sud)

					if solutions.count == amountOfSolutions {
						return solutions
					}
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

		return solutions
	}

	public func constraints(_ sudoku: Sudoku) -> [Constraint] {
		return sudoku.getOpenPositions().map { pos -> Constraint in
			Constraint(position: pos,
			           values: freeAtPosition(sudoku: sudoku,
			                                 row: pos.row,
											  col: pos.column))
		}.sorted(by: {
			$0.values.count < $1.values.count
		})
	}

	public func consistent(_ sudoku: Sudoku) -> Bool {
		for i in 0 ..< sudoku.count {
			if !validRow(sudoku: sudoku, row: i) || !validCol(sudoku: sudoku, col: i) {
				return false
			}
		}

		for pos in sudoku.getSubGridsStartPosition() {
			if !validSubGrid(sudoku: sudoku, row: pos.row, col: pos.column) {
				return false
			}
		}

		return true
	}

	public func validRow(sudoku: Sudoku, row: Int) -> Bool {
		return freeInRow(sudoku: sudoku, row: row).isEmpty
	}

	public func validCol(sudoku: Sudoku, col: Int) -> Bool {
		return freeInCol(sudoku: sudoku, col: col).isEmpty
	}

	public func validSubGrid(sudoku: Sudoku, row: Int, col: Int) -> Bool {
		return freeInSubGrid(sudoku: sudoku, row: row, col: col).isEmpty
	}

	public func freeInRow(sudoku: Sudoku, row: Int) -> [Int] {
		return freeIn(sudoku.getRow(row))
	}

	public func freeInCol(sudoku: Sudoku, col: Int) -> [Int] {
		return freeIn(sudoku.getCol(col))
	}

	public func freeInSubGrid(sudoku: Sudoku, row: Int, col: Int) -> [Int] {
		return freeIn(sudoku.getSubGrid(row: row, col: col))
	}

	public func freeAtPosition(sudoku: Sudoku, row: Int, col: Int) -> [Int] {
		let freeInRow = Set(freeInRow(sudoku: sudoku, row: row))
		let freeInCol = Set(freeInCol(sudoku: sudoku, col: col))
		let freeInSubGrid = Set(freeInSubGrid(sudoku: sudoku, row: row, col: col))

		return Array(freeInRow.intersection(freeInCol)
			.intersection(freeInSubGrid))
	}

	private func freeIn(_ sequence: [Int?]) -> [Int] {
		if sequence.isEmpty {
			return []
		}

		let n = Array(1 ... sequence.count)

		let sequenceSet = Set(sequence.compacted())
		let nSet = Set(n)

		return Array(nSet.symmetricDifference(sequenceSet)).sorted()
	}
}
