@testable import Sudoku_Solver
import XCTest

class SudokuTests: XCTestCase {
	let string = """
	3 9 6 8 5 1 7 4 2
	1 7 8 2 9 4 3 5 6
	5 2 4 6 7 3 8 9 1
	9 1 5 4 8 7 2 6 3
	4 8 3 9 2 6 5 1 7
	2 6 7 3 1 5 9 8 4
	6 5 2 1 3 8 4 7 9
	7 4 9 5 6 2 1 3 8
	8 3 1 7 4 9 6 2 5
	"""

	func testParse() {
		let sudoku = """
		3 9 6 8 5 1 7 4 2
		1 7 8 2 9 4 3 5 6
		5 2 4 6 7 3 8 9 1
		9 1 5 4 8 7 2 6 3
		4 8 3 9 2 6 5 1 7
		2 6 7 3 1 5 9 8 4
		6 5 2 1 3 8 4 7 9
		7 4 9 5 6 2 1 3 8
		8 3 1 7 4 0 6 2 5
		"""

		let expected: Sudoku = [
			[3, 9, 6, 8, 5, 1, 7, 4, 2],
			[1, 7, 8, 2, 9, 4, 3, 5, 6],
			[5, 2, 4, 6, 7, 3, 8, 9, 1],
			[9, 1, 5, 4, 8, 7, 2, 6, 3],
			[4, 8, 3, 9, 2, 6, 5, 1, 7],
			[2, 6, 7, 3, 1, 5, 9, 8, 4],
			[6, 5, 2, 1, 3, 8, 4, 7, 9],
			[7, 4, 9, 5, 6, 2, 1, 3, 8],
			[8, 3, 1, 7, 4, nil, 6, 2, 5]
		]

		XCTAssertEqual(Sudoku.parse(sudoku), expected, "Parsed sudoku does not match the expected sudoku")
	}

	func testExtend() {
		let expected = """
		3 9 6 8 5 1 7 4 2
		1 7 8 2 9 4 3 5 6
		5 2 4 6 7 3 8 9 1
		9 1 5 4 8 7 2 6 3
		4 8 3 9 2 6 5 1 7
		2 6 7 3 1 5 9 8 4
		6 5 2 1 3 8 4 7 9
		7 4 9 5 6 2 1 3 8
		8 3 1 7 4 9 6 2 5
		"""

		let sudokuStr = """
		0 9 6 8 5 1 7 4 2
		1 7 8 2 9 4 3 5 6
		5 2 4 6 7 3 8 9 1
		9 1 5 4 8 7 2 6 3
		4 8 3 9 2 6 5 1 7
		2 6 7 3 1 5 9 8 4
		6 5 2 1 3 8 4 7 9
		7 4 9 5 6 2 1 3 8
		8 3 1 7 4 9 6 2 5
		"""

		let sudoku = Sudoku.parse(sudokuStr)

		XCTAssertEqual(sudoku.extend(row: 0, column: 0, value: 3), Sudoku.parse(expected), "Sudoku did not extend")
	}

	func testExtendMakesCopy() {
		let sudokuStr = """
		0 9 6 8 5 1 7 4 2
		1 7 8 2 9 4 3 5 6
		5 2 4 6 7 3 8 9 1
		9 1 5 4 8 7 2 6 3
		4 8 3 9 2 6 5 1 7
		2 6 7 3 1 5 9 8 4
		6 5 2 1 3 8 4 7 9
		7 4 9 5 6 2 1 3 8
		8 3 1 7 4 9 6 2 5
		"""

		let sudoku = Sudoku.parse(sudokuStr)
		let sudoku2 = sudoku.extend(row: 0, column: 0, value: 3)

		XCTAssertNotEqual(sudoku, sudoku2, "Extend made no copies, both sudokus are equal")
	}

	func testGetRow() {
		let sudoku = Sudoku.parse(self.string)
		XCTAssertEqual(sudoku.getRow(0), [3, 9, 6, 8, 5, 1, 7, 4, 2])
	}

	func testGetCol() {
		let sudoku = Sudoku.parse(self.string)
		XCTAssertEqual(sudoku.getCol(0), [3, 1, 5, 9, 4, 2, 6, 7, 8])
	}

	func testGetSubGrid() {
		let sudoku = Sudoku.parse(self.string)
		XCTAssertEqual(sudoku.getSubGrid(row: 0, col: 0), [3, 9, 6, 1, 7, 8, 5, 2, 4])
	}

	func testGetSubGrids() {
		let sudoku = Sudoku.parse(self.string)
		print(sudoku.getSubGrids())
		XCTAssertEqual(sudoku.getSubGrids(), [
			[
				3, 9, 6,
				1, 7, 8,
				5, 2, 4
			],
			[
				8, 5, 1,
				2, 9, 4,
				6, 7, 3
			],
			[
				7, 4, 2,
				3, 5, 6,
				8, 9, 1
			],
			[
				9, 1, 5,
				4, 8, 3,
				2, 6, 7
			],
			[
				4, 8, 7,
				9, 2, 6,
				3, 1, 5
			],
			[
				2, 6, 3,
				5, 1, 7,
				9, 8, 4
			],
			[
				6, 5, 2,
				7, 4, 9,
				8, 3, 1
			],
			[
				1, 3, 8,
				5, 6, 2,
				7, 4, 9
			],
			[
				4, 7, 9,
				1, 3, 8,
				6, 2, 5
			]
		])
	}

	func testgetSubGridsStartPosition() {
		let sudoku = Sudoku.parse(self.string)
		print(sudoku.getSubGridsStartPosition())
	}

	func testgetOpenPositions() {}

	func testHeight() {
		let sudoku: Sudoku = [
			[3, 9, 6, 8, 5, 1, 7, 4, 2],
			[1, 7, 8, 2, 9, 4, 3, 5, 6],
			[5, 2, 4, 6, 7, 3, 8, 9, 1],
			[9, 1, 5, 4, 8, 7, 2, 6, 3],
			[4, 8, 3, 9, 2, 6, 5, 1, 7],
			[2, 6, 7, 3, 1, 5, 9, 8, 4],
			[6, 5, 2, 1, 3, 8, 4, 7, 9],
			[7, 4, 9, 5, 6, 2, 1, 3, 8],
			[8, 3, 1, 7, 4, 9, 6, 2, 5]
		]

		let expected = 9

		XCTAssertEqual(sudoku.height, expected, "The expected heigth of \(expected) is not returned")
	}

	func testWidth() {
		let sudoku: Sudoku = [
			[3, 9, 6, 8, 5, 1, 7, 4, 2],
			[1, 7, 8, 2, 9, 4, 3, 5, 6],
			[5, 2, 4, 6, 7, 3, 8, 9, 1],
			[9, 1, 5, 4, 8, 7, 2, 6, 3],
			[4, 8, 3, 9, 2, 6, 5, 1, 7],
			[2, 6, 7, 3, 1, 5, 9, 8, 4],
			[6, 5, 2, 1, 3, 8, nil, 7, 9],
			[7, 4, 9, 5, 6, 2, 1, 3, 8],
			[nil, 3, 1, 7, 4, 9, 6, 2, 5]
		]

		let expected = 9

		XCTAssertEqual(sudoku.width, expected, "The expected width of \(expected) is not returned")
	}
}
