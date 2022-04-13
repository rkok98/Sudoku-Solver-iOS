import Foundation

public class SudokuInputViewController {
	public func temp() -> [SubGrid] {
		let str = sudokus.randomElement()!
		return Sudoku.parse(str).getSubGrids()
	}

	public func show(_ sudoku: Sudoku) -> [SubGrid] {
		return sudoku.getSubGrids()
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

	public func solve(_ sudoku: Sudoku) -> Sudoku {
		return SudokuSolver.solve(sudoku)[0]
	}

	public func printValues(_ values: [SubGrid]) {
		print(values)
	}
}
