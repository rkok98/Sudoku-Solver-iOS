import Foundation
import SwiftUI

public class SudokuInputViewController: ObservableObject {
	public func random() -> [SubGrid] {
		let str = sudokus.randomElement()!
		return Sudoku.parse(str).getGrids(Sudoku.blocks)
	}

	public func show(_ sudoku: Sudoku) -> [SubGrid] {
		return sudoku.getGrids(Sudoku.blocks)
	}

	public func clear(nrOfSubGrids: Int) -> [SubGrid] {
		return Array(repeating: Array(repeating: nil, count: nrOfSubGrids), count: nrOfSubGrids)
	}

	public func parseSudoku(_ values: [SubGrid]) -> Sudoku {
		let sqrt = Int(Double(values.count).squareRoot())
		var sudoku: Sudoku = Array(repeating: Array(repeating: 0, count: values.count), count: values.count)

		for (i, subGrid) in values.enumerated() {
			for (j, val) in subGrid.enumerated() {
				let row = (i / sqrt) % values.count * sqrt + (j / sqrt)
				let col = ((i * sqrt) + (j % sqrt)) % values.count

				sudoku[row][col] = val ?? nil
			}
		}

		return sudoku
	}

	public func solve(_ sudoku: Sudoku) throws -> Sudoku {
		let solver = SudokuSolver()
		return try solver.solve(sudoku)
	}

	public func printValues(_ values: [SubGrid]) {
		print(values)
	}
}
