import XCTest

class SudokuSolverTests: XCTestCase {
	let solver = SudokuSolver()

	func testGetGridsStartPosition() {
		let expected = [Position(0, 0), Position(0, 3), Position(0, 6),
		                Position(3, 0), Position(3, 3), Position(3, 6),
		                Position(6, 0), Position(6, 3), Position(6, 6)]

		let blocks = [[Int](0...2), [Int](3...5), [Int](6...8)]

		XCTAssertEqual(solver.getGridsStartPositions(blocks), expected)
	}

	func testSolve() {
		let expected = """
		1 7 2 5 4 9 6 8 3
		6 4 5 8 7 3 2 1 9
		3 8 9 2 6 1 7 4 5
		4 9 6 3 2 7 8 5 1
		8 1 3 4 5 6 9 7 2
		2 5 7 1 9 8 4 3 6
		9 6 4 7 1 5 3 2 8
		7 3 1 6 8 2 5 9 4
		5 2 8 9 3 4 1 6 7
		"""

		let sudokuStr = """
		0 0 0 0 0 0 6 8 0
		0 0 0 0 7 3 0 0 9
		3 0 9 0 0 0 0 4 5
		4 9 0 0 0 0 0 0 0
		8 0 3 0 5 0 9 0 2
		0 0 0 0 0 0 0 3 6
		9 6 0 0 0 0 3 0 8
		7 0 0 6 8 0 0 0 0
		0 2 8 0 0 0 0 0 0
		"""

		let sudoku = Sudoku.parse(sudokuStr)

		XCTAssertEqual(try solver.solve(sudoku).description, expected)
	}

	func testSolveThrowsError() {
		let unsolvable = """
		8 1 2 7 5 3 6 4 9
		9 4 3 6 8 2 1 7 5
		6 7 5 4 9 1 2 8 3
		1 5 4 2 3 7 8 9 6
		3 6 9 8 4 5 7 2 1
		2 8 7 1 6 9 5 3 4
		5 2 1 9 7 4 3 6 8
		4 3 8 5 2 6 9 1 7
		7 9 6 3 1 8 4 4 0
		"""

		let sudoku = Sudoku.parse(unsolvable)

		XCTAssertThrowsError(try solver.solve(sudoku))
	}
}
