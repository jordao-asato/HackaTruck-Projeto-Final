import Foundation

class apiDELETEARDUINO: ObservableObject {
   
    func delete(_ objeto: sinal) {
//                , completion: @escaping (Result<Void, Error>) -> Void) {
       
        guard let url = URL(string: "http://127.0.0.1:1880/arduDELETE") else {
//            let error = NSError(domain: "URLCreationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])
//            completion(.failure(error))
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
//                    completion(.failure(error))
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    print("Recurso deletado com sucesso no servidor.")
//                    completion(.success(()))
                } else {
                    let error = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Erro do servidor ao deletar: código \(httpResponse.statusCode)"])
//                    completion(.failure(error))
                }
            }
        }
        task.resume()
        
//        if let index =
    }
}
