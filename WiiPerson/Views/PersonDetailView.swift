import SwiftUI
import WiiKit

struct PersonDetailView: View {
    @EnvironmentObject var personnelModel: PersonnelModel
    
    var person: Person
    
    @State private var data = Person.Data()
    @State private var isPresentingEditView = false
    
    var body: some View {
        ScrollView {
            Image("cup")
                .resizable()
                .scaledToFit()
            
            CircleImage(person: person)
                .offset(y: -100)
                .padding(.bottom, -100)

            VStack(alignment: .leading) {
                Text(person.surname)
                    .font(.title)
                    .bold()
                
                HStack {
                    Text(person.name)
                    Text(person.middleName)
                }
                .font(.title2)
                .padding(.bottom, 5)
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        if person.position != nil {
                            Text("\(person.position!)")
                        } else {
                            Text("No positional data")
                        }
                        Spacer()
                        Text("смена \(person.shiftNum!) РДЦ")
                    }
                    HStack {
                        Text("Табельный номер \(person.tabNumString)")
                        Spacer()
                        if let klass = person.klass {
                            Text("\(klass) класс")
                        }
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Пол:")
                        Text("\(person.sex.label)")
                            .foregroundColor(person.sex.color)
                    }
                    HStack {
                        Text("Дата рождения:")
                        Text(person.birthDate)
                        Text(" (\(person.age!) лет)")
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.green)
                        Text("\(person.phoneNumber)")
                    }
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.blue)
                        if person.email != nil {
                            Text(person.email!)
                        } else {
                            Text("No email")
                        }
                    }
                }
                
                Divider()
                
                Text("Дополнительные сведения")

                if person.note != nil {
                    Text(person.note!)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text("Дополнительные сведения отсутствуют")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Edit") {
                isPresentingEditView.toggle()
                data = person.data
            }
        }
        .sheet(isPresented: $isPresentingEditView) {
            NavigationView {
                PersonEditView(data: $data)
                    .navigationTitle(person.surname)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingEditView.toggle()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                isPresentingEditView.toggle()
                                person.sqlUpdatePerson(from: data)
                                personnelModel.reload()
                            }
                        }
                    }
            }
        }
    }
}

struct PersonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PersonDetailView(person: Person.samples[0])
    }
}
