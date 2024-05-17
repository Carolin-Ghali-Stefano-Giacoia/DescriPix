import Foundation
import UIKit

func uploadImage(selectedImage: UIImage, text: String, completion: @escaping (String) -> Void) {
    print("Entro in uploadImage...")

    let imageData = selectedImage.jpegData(compressionQuality: 0.5)
    // Aggiornato con il nuovo URL del server
    let url = URL(string: "https://develop.ewlab.di.unimi.it/descripix/predict")!

    // Costruisci la richiesta HTTP
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Costruisci il body della richiesta
    let base64String = imageData?.base64EncodedString() ?? ""
    let json = [
        "text": text, // Sostituisci con il testo che vuoi inviare
        "image": "data:image/jpeg;base64,\(base64String)"
    ]
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
    request.httpBody = jsonData
    
    // Invia la richiesta
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
        
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
               let generatedText = jsonResponse["generated_text"] as? String {
                completion(generatedText)
            }
        } catch let error {
            print("Errore durante la deserializzazione del JSON", error)
        }
    }.resume()

}
