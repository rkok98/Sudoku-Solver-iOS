

public struct Position: CustomStringConvertible {
	public let row: Int
	public let column: Int

	public init(_ row: Int, _ col: Int) {
		self.row = row
		self.column = col
	}

	public var description: String {
		return "(\(row), \(column))"
	}
}
