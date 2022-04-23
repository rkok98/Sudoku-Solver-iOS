import SwiftUI

struct SudokuCellView: View {
	private let nrcBlocks = [[Int](1...3), [Int](5...7)].joined()

	private let row: Int
	private let col: Int

	private var id: String

	@Binding var value: Int?
	@Binding var isNRCSudoku: Bool

	@FocusState var focusedField: String?

	public init(row: Int, col: Int, value: Binding<Int?>, isNRCSudoku: Binding<Bool>, focusedField: FocusState<String?>) {
		self.row = row
		self.col = col

		self._value = value
		self._isNRCSudoku = isNRCSudoku
		self._focusedField = focusedField

		self.id = "\(row)-\(col)"
	}

	private func changeFocus() {
		if col < 8 {
			focusedField = "\(row)-\(col + 1)"
		} else if row < 8 {
			focusedField = "\(row + 1)-0"
		}
	}

	private func isNRCGrid() -> Bool {
		return nrcBlocks.contains(row) && nrcBlocks.contains(col)
	}

	var body: some View {
		TextField("", value: $value, format: .number)
			.keyboardType(UIKeyboardType.numbersAndPunctuation)
			.disableAutocorrection(true)
			.font(Font.system(size: 32, design: .default))
			.foregroundColor(Color.primary)
			.multilineTextAlignment(.center)
			.border(Color.primary.opacity(0.2))
			.focused($focusedField, equals: self.id)
			.submitLabel(.next)
			.onSubmit(changeFocus)
			.background(isNRCGrid() && isNRCSudoku ? Color(uiColor: UIColor.secondarySystemBackground) : Color(uiColor: UIColor.systemBackground))
	}
}

struct SudokuView: View {
	@Binding var values: [Int?]
	@Binding var isNRCSudoku: Bool

	@State var columns: [GridItem]

	@FocusState var focusedField: String?

	private let controller = SudokuInputViewController()
	private let spacing: CGFloat = 0
	private let width: Int

	init(_ values: Binding<[Int?]>, width: Int, isNRCSudoku: Binding<Bool>) {
		self._values = values
		self.width = width
		self._isNRCSudoku = isNRCSudoku

		self._columns = State<[GridItem]>(initialValue: Array(repeating: GridItem(.flexible(), spacing: spacing, alignment: .center), count: 9))
	}

	var body: some View {
		LazyVGrid(columns: columns, spacing: spacing) {
			ForEach(0 ..< values.count, id: \.self) { i in
				let row = i / width
				let col = i % width

				SudokuCellView(row: row, col: col, value: $values[i], isNRCSudoku: $isNRCSudoku, focusedField: _focusedField)
			}
		}.mask(RoundedRectangle(cornerRadius: 12.5))
			.background(RoundedRectangle(cornerRadius: 12.5)
				.background(RoundedRectangle(cornerRadius: 12.5)
					.fill(Color(uiColor: UIColor.tertiarySystemBackground))))
	}
}

struct SudokuInputView: View {
	@StateObject private var controller = SudokuInputViewController()

	@State var isUnsolvable: Bool = false
	@State var isNRCSudoku: Bool = false
	@State var values: [Int?]

	private let padding: CGFloat = 16.0
	private let width: Int

	public init(width: Int = 9) {
		let nrOfValues = width * width

		self.width = width
		self.values = Array(repeating: nil, count: nrOfValues)
	}

	private func solve() {
		hideKeyboard()

		let sudoku = controller.toSudoku(values, width: width)
		let solver = isNRCSudoku ? NRCSudokuSolver() : SudokuSolver()

		do {
			let solved = try controller.solve(sudoku, solver: solver)
			values = controller.fromSudoku(solved)
		} catch {
			isUnsolvable = true
		}
	}

	private func random() {
		hideKeyboard()
		values = controller.random(isNRCSudoku: isNRCSudoku)
	}

	private func clear() {
		hideKeyboard()
		values = controller.clear(width: width)
	}

	var body: some View {
		NavigationView {
			ScrollView {
				VStack {
					Picker("Sudoku type", selection: $isNRCSudoku) {
						Text("Normal").tag(false)
						Text("NRC Sudoku").tag(true)
					}.pickerStyle(.segmented)
						.padding(padding)
					ZStack {
						SudokuView($values, width: width, isNRCSudoku: $isNRCSudoku)
							.padding(padding)
					}.alert("Sudoku is unsolvable", isPresented: $isUnsolvable) {
						Button("OK") {
							isUnsolvable = false
						}
					}
					HStack {
						Spacer()
						Button("Solve Sudoku", action: solve)
							.buttonStyle(.borderedProminent)
							.padding(padding)
						Button("Clear Sudoku", role: .destructive, action: clear)
						Spacer()
					}
				}
			}.navigationTitle("Sudoku Solver")
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button("Random Sudoku", action: random)
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Hide Keyboard", role: .destructive, action: hideKeyboard)
					}
				}
		}.navigationViewStyle(StackNavigationViewStyle())
	}
}

struct SudokuInputView_Previews: PreviewProvider {
	static var previews: some View {
		SudokuInputView()
			.previewDevice("iPad Air (5th generation)")
			.previewInterfaceOrientation(.portrait)
	}
}

#if canImport(UIKit)
extension View {
	func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
#endif
