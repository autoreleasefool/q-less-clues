import Foundation

extension Date {
	private static let formatter: RelativeDateTimeFormatter = {
		let formatter = RelativeDateTimeFormatter()
		formatter.dateTimeStyle = .numeric
		return formatter
	}()

	public var formattedRelative: String {
		if Calendar.current.isDateInToday(self) {
			return "Today"
		} else if Calendar.current.isDateInYesterday(self) {
			return "Yesterday"
		} else {
			return Self.formatter.localizedString(for: self, relativeTo: Date())
		}
	}
}
