import Foundation

class apiDELETE: ObservableObject {
   
    func delete(_ objeto: Remedio) {
       
        guard let url = URL(string: "http://127.0.0.1:1880/remedioDELETE") else {

            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        do{
            let data = try JSONEncoder().encode(objeto)
            
            request.httpBody = data
        }
        catch{
            print("ndasjkb")
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Erro de rede ao deletar: \(error.localizedDescription)")
//                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = NSError(domain: "ResponseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Resposta inválida do servidor"])

                    return
                }
                
                if httpResponse.statusCode == 200 {
                    print("Recurso deletado com sucesso no servidor.")

                } else {
                    let error = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Erro do servidor ao deletar: código \(httpResponse.statusCode)"])

                }
            }
        }
        task.resume()
        
//        if let index =
    }
}
