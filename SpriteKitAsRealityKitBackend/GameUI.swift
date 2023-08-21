import Foundation
import SwiftUI

struct GameUI: View
{
    var body: some View
    {
        VStack
        {
            Button("This is a SwiftUI button 🐭") {
                
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding(20)
    }
}

struct GameUI_Previews: PreviewProvider
{
    static var previews: some View
    {
        GameUI()
    }
}
