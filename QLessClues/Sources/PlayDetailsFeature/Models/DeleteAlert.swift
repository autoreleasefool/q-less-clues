import ComposableArchitecture

public enum DeletePlayAlertAction: Equatable {
	case deleteButtonTapped
	case nevermindButtonTapped
	case dismissed
}

let deleteAlert = AlertState<DeletePlayAlertAction>(
	title: .init("Do you want to delete this play?"),
	primaryButton: .destructive(
		.init("Delete"),
		action: .send(.deleteButtonTapped)
	),
	secondaryButton: .cancel(
		.init("Nevermind"),
		action: .send(.nevermindButtonTapped)
	)
)
