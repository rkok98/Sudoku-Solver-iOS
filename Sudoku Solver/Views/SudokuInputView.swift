import SwiftUI

struct SudokuCellView: View {
	private let grid: Int
	private let cell: Int

	private var id: String

	@Binding var value: Int?

	@FocusState var focusedField: String?

	public init(grid: Int, cell: Int, value: Binding<Int?>, focusedField: FocusState<String?>) {
		self.grid = grid
		self.cell = cell
		self._value = value
		self._focusedField = focusedField

		self.id = "\(grid)-\(cell)"
	}

	private func changeFocus() {
		if cell < 8 {
			focusedField = "\(grid)-\(cell + 1)"
		} else if grid < 8 {
			focusedField = "\(grid + 1)-0"
		}
	}

	var body: some View {
		TextField("", value: $value, format: .number)
			.keyboardType(UIKeyboardType.default)
			.font(Font.system(size: 32, design: .default))
			.foregroundColor(Color.primary)
			.multilineTextAlignment(.center)
			.border(Color.primary.opacity(0.2))
			.focused($focusedField, equals: self.id)
			.submitLabel(.next)
			.onSubmit(changeFocus)
	}
}

struct SudokuSubGrid: View {
	let id: Int

	@FocusState var focusedField: String?
	@State private var columns: [GridItem]

	@Binding var subGrid: SubGrid

	static let spacing: CGFloat = 0

	init(_ subGrid: Binding<SubGrid>, id: Int, focusedField: FocusState<String?>) {
		self.id = id
		self._subGrid = subGrid
		self._focusedField = focusedField

		let sqrt = Int(Double(subGrid.count).squareRoot())
		self._columns = State<[GridItem]>(initialValue: Array(repeating: GridItem(.flexible(), spacing: SudokuSubGrid.spacing, alignment: .center), count: sqrt))
	}

	var body: some View {
		LazyVGrid(columns: columns, spacing: SudokuSubGrid.spacing) {
			ForEach(0 ..< subGrid.count, id: \.self) { i in
				SudokuCellView(grid: id, cell: i, value: $subGrid[i], focusedField: _focusedField)
					.padding(0)
			}
		}.background(Rectangle()
			.strokeBorder(Color.primary, lineWidth: 2))
	}
}

struct SudokuView: View {
	private let controller = SudokuInputViewController()
	private let spacing: CGFloat = 0

	@FocusState var focusedField: String?

	@Binding var subGrids: [SubGrid]
	@State var isSolving: Bool = false

	@State var columns: [GridItem]

	init(_ subGrids: Binding<[SubGrid]>) {
		self._subGrids = subGrids

		let sqrt = Int(Double(subGrids.count).squareRoot())
		self._columns = State<[GridItem]>(initialValue: Array(repeating: GridItem(.flexible(), spacing: SudokuSubGrid.spacing, alignment: .center), count: sqrt))
	}

	var body: some View {
		ZStack {
			LazyVGrid(columns: columns, spacing: SudokuSubGrid.spacing) {
				ForEach(0 ..< subGrids.count, id: \.self) { i in
					SudokuSubGrid($subGrids[i], id: i, focusedField: _focusedField)
				}
			}
		}.mask(RoundedRectangle(cornerRadius: 12.5))
			.background(RoundedRectangle(cornerRadius: 12.5)
				.strokeBorder(Color.primary, lineWidth: 4)
				.background(RoundedRectangle(cornerRadius: 12.5)
					.fill(Color(uiColor: UIColor.tertiarySystemBackground))))
	}
}

struct SudokuInputView: View {
	@StateObject private var controller = SudokuInputViewController()

	@State var isSolving: Bool = false
	@State var subGrids: [SubGrid]

	public init(nrOfSubGrids: Int = 9) {
		self.subGrids = Array(repeating: Array(repeating: nil, count: nrOfSubGrids), count: nrOfSubGrids)
	}

	private func solve() {
		hideKeyboard()

		isSolving = true

		let sudoku = controller.parseSudoku(subGrids)
		let solved = controller.solve(sudoku)

		subGrids = controller.show(solved)

		isSolving = false
	}

	private func random() {
		hideKeyboard()
		subGrids = controller.random()
	}

	private func clear() {
		hideKeyboard()
		subGrids = controller.clear(nrOfSubGrids: subGrids.count)
	}

	var body: some View {
		NavigationView {
			ScrollView {
				ZStack {
					VStack {
						HStack {
							Spacer()
							SudokuView($subGrids)
							Spacer()
						}
						HStack {
							Button("Solve 🤓", action: solve)
								.buttonStyle(.borderedProminent)
								.padding(16)
						}
					}
				}
			}.navigationTitle("Sudoku Solver")
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button("Random 🎲", action: random)
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Clear 💣", role: .destructive, action: clear)
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
