import SwiftUI
import WiiKit

struct CircleImage: View {
    var person: Person
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 217, height: 217)
                .overlay {
                    Circle().fill(Color.white)
                }
                .overlay {
                    Circle().stroke(Color.white)
                }

            person.image
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(Color.white, lineWidth: 6)
                }
                .overlay {
                    Circle().stroke(person.sex.color, lineWidth: 3)

                }
        }
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(person: Person.samples[0])
    }
}
