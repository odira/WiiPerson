import SwiftUI
import WiiKit

struct PersonDetailView: View {
    @EnvironmentObject var personnelModel: PersonnelModel
    @EnvironmentObject var positionModel: PositionModel
    @EnvironmentObject var sectorsPoolModel: SectorsPoolModel
    @EnvironmentObject var sectorModel: SectorModel
    
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
                    VStack(alignment: .leading, spacing: 3) {
                        positionAndShiftNumView()
                        tabNumAndClassView()
                        sectorPoolView()
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 3) {
                        sexView()
                        birthdayView()
                        phoneView()
                        emailView()
                    }
                    Divider()
                    sectorsView()
                    Divider()
                    positionAdmissionsView()
                    Divider()
                    noteView()
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Edit") {
                data = person.data
                isPresentingEditView.toggle()
            }
        }
        .sheet(isPresented: $isPresentingEditView) {
            NavigationView {
                PersonEditView(data: $data)
                    .navigationTitle("Editing Mode")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") {
                                isPresentingEditView.toggle()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                isPresentingEditView.toggle()
                                personnelModel.sqlPersonUPDATE(person, with: data)
                            }
                        }
                    }
            }
        }
    }
}

struct PersonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PersonDetailView(person: Person.samples[0])
                .preferredColorScheme(.light)
            PersonDetailView(person: Person.samples[0])
                .preferredColorScheme(.dark)
        }
        .environmentObject(PositionModel())
        .environmentObject(SectorsPoolModel())
        .environmentObject(SectorModel())
    }
}

extension PersonDetailView {
    func positionAndShiftNumView() -> some View {
        HStack {
            if let position = positionModel.findPosition(for: person) {
                PositionCard(for: position)
            } else {
                Text("No positional data")
            }
            Spacer()
            ShiftCard(shift: person.shiftNum!)
        }
    }
    
    func tabNumAndClassView() -> some View {
        HStack {
            Text("?????????????????? ?????????? \(person.tabNumString)")
            Spacer()
            if let klass = person.klass {
                Text("\(klass) ??????????")
            }
        }
    }
    
    func sexView() -> some View {
        HStack {
            Text("??????:")
            Text("\(person.sex.rulabel)")
                .foregroundColor(person.sex.color)
        }
    }
    
    func birthdayView() -> some View {
        HStack {
            if person.birthday != nil {
                Text("???????? ????????????????:")
                Text(person.birthDate)
                Text(" (\(person.age!) ??????)")
            } else {
                EmptyView()
            }
        }
    }
    
    func phoneView() -> some View {
        HStack {
            Image(systemName: "phone.fill")
                .foregroundColor(.green)
            Text("\(person.phoneNumber)")
        }
    }
    
    func emailView() -> some View {
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
    
    func sectorPoolView() -> some View {
        HStack {
            Text("??????????????????????")
            if let id = person.sectorsPoolId {
                let pool = sectorsPoolModel.findSectorsPool(byId: id)
                SectorsPoolCard(for: pool!)
            }
        }
    }
    
    func sectorsView() -> some View {
        VStack(alignment: .leading) {
            Text("?????????????? ???? ????????????????")
            SectorsArrayView(for: person.sectorsArr)
        }
    }
    
    func positionAdmissionsView() -> some View {
        VStack(alignment: .leading) {
            Text("?????????????? ?? ????????????")
            PositionsArrayView(positionsArr: person.positionsArr)
        }
    }
    
    func noteView() -> some View {
        VStack(alignment: .leading) {
            Text("???????????????????????????? ????????????????")
            if person.note != nil {
                Text(person.note!)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                Text("???????????????????????????? ???????????????? ??????????????????????")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
