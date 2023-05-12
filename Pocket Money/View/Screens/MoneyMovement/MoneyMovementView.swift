//
//  RecordExpensesView.swift
//  Pocket Money
//
//  Created by Rodrigo Oliveira on 11/05/23.
//

import SwiftUI
// MARK: - MODEL
struct Movimentation: Codable {
    let id: String
    let description: String
    let value: Double
    let type: String
    let kidId: String
    let createdAt: String
    let updatedAt: String
}

struct MovimentationRequest: Codable {
    var description = String()
    var value = String()
    var type = String()
}

class TextBindingManager: ObservableObject {
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    let characterLimit: Int

    init(limit: Int = 5){
        characterLimit = limit
    }
}

enum TypeMovement: String {
    case spent = "Gasto"
    case saveMoney = "Guardado"
    case deposit = "Depósito"
    case withdraw = "Sacar"
}

enum TitlePages: String {
    case titleRecordExpenses = "Registrar Gastos"
    case titleSaveMoney = "Guardar Dinheiro"
    case titleDeposit = "Depositar"
    case titleWithdraw = "Sacar"
}


// MARK: VIEWMODEL
struct MoneyMovementViewModel {
    var movimentationRequest = MovimentationRequest()
    @State var hasUrl = "https://jab-api-xh0g.onrender.com/api/v1//movimentations"
    @EnvironmentObject  var singInViewModel: SingInViewModel
    
    func movimentation(id: String?) async {
        guard let encoded = try? JSONEncoder().encode(movimentationRequest) else {
            print("Failed to encode order")
            return
        }
        if let hasId = id {
            hasUrl = "\(hasUrl)/\(hasId)"
        }
        guard let url = URL(string: hasUrl) else {return}
        var request = URLRequest(url: url)
        let authorizationKey = "Bearer ".appending(singInViewModel.token)
        request.setValue(authorizationKey, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let userCreated = try JSONDecoder().decode(Movimentation.self, from: data)
        } catch  {
            print(String(describing: error))
            print(error.localizedDescription)
        }
    }
}

struct MoneyMovementPerUser: View {
    @ObservedObject var description = TextBindingManager(limit: 137)
    @EnvironmentObject  var singInViewModel: SingInViewModel
    @State var moneyMovementViewModel = MoneyMovementViewModel()
    var id: String
    var typeMovement: TypeMovement
    var title: TitlePages
    @State private var type = String()
    @State private var isSubtitleHidden = false
    @State private var value = 0
    
    private var numberFormatter: NumberFormatter
    
    init(numberFormatter: NumberFormatter = NumberFormatter(), id: String?, typeMovement: TypeMovement?, title: TitlePages) {
        self.numberFormatter = numberFormatter
        self.numberFormatter.locale = Locale(identifier: "pt_BR")
        self.numberFormatter.numberStyle = .currency
        self.numberFormatter.maximumFractionDigits = 2
        
        self.id = id ?? String()
        self.typeMovement = typeMovement ?? .spent
        self.title = title
    }

    
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    VStack{
                        HStack{
                            Image(systemName: "dollarsign")
                                .foregroundColor(.purple)
                            CurrencyTextField(numberFormatter: numberFormatter, value: $value)
                                          .frame(height: 4)
                                      Rectangle()
                                          .frame(width: 0, height: 10)
                        }
                        .textFieldBorderIcon()
                        HStack{
                            Image(systemName: "note.text")
                                .foregroundColor(.purple)
                            TextField("Descrição", text: $description.text, axis: .vertical)
                                .lineLimit(4)
                                .fontWeight(.medium)
                        }
                        .textFieldBorderIcon()
                        
                        Button {
                            Task{
                                await moneyMovementViewModel.movimentation(id: id)
                            }
                        } label: {
                            Text("Registrar")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(4)
                        }
                        .padding(.horizontal, 20)
                        .buttonStyle(.borderedProminent)
                        .tint(.purple)
                        .padding(.vertical)
                    }
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                }
                .navigationTitle(title.rawValue)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct MoneyMovement_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            MoneyMovementPerUser(id: "", typeMovement: .spent, title: .titleRecordExpenses)
        }
    
    }
}

struct CurrencyTextField: UIViewRepresentable {
    
    typealias UIViewType = CurrencyUITextField
    
    let numberFormatter: NumberFormatter
    let currencyField: CurrencyUITextField
    
    init(numberFormatter: NumberFormatter, value: Binding<Int>) {
        self.numberFormatter = numberFormatter
        currencyField = CurrencyUITextField(formatter: numberFormatter, value: value)
    }
    
    func makeUIView(context: Context) -> CurrencyUITextField {
        return currencyField
    }
    
    func updateUIView(_ uiView: CurrencyUITextField, context: Context) { }
}



import UIKit
class CurrencyUITextField: UITextField {
    
    @Binding private var value: Int
    private let formatter: NumberFormatter
    
    init(formatter: NumberFormatter, value: Binding<Int>) {
        self.formatter = formatter
        self._value = value
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        addTarget(self, action: #selector(resetSelection), for: .allTouchEvents)
        keyboardType = .numberPad
        textAlignment = .right
        sendActions(for: .editingChanged)
    }
    
    override func deleteBackward() {
        text = textValue.digits.dropLast().string
        sendActions(for: .editingChanged)
    }
    
    private func setupViews() {
        tintColor = .clear
        font = .systemFont(ofSize: 24, weight: .regular)
    }
    
    @objc private func editingChanged() {
        text = currency(from: decimal)
        resetSelection()
        value = Int(doubleValue * 100)
    }
    
    @objc private func resetSelection() {
        selectedTextRange = textRange(from: endOfDocument, to: endOfDocument)
    }
    
    private var textValue: String {
        return text ?? ""
    }

    private var doubleValue: Double {
      return (decimal as NSDecimalNumber).doubleValue
    }

    private var decimal: Decimal {
      return textValue.decimal / pow(10, formatter.maximumFractionDigits)
    }
    
    private func currency(from decimal: Decimal) -> String {
        return formatter.string(for: decimal) ?? ""
    }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    var digits: Self { filter (\.isWholeNumber) }
}

extension String {
    var decimal: Decimal { Decimal(string: digits) ?? 0 }
}

extension LosslessStringConvertible {
    var string: String { .init(self) }
}
