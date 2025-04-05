import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String apiKey = "AIzaSyAl5zDBHJYkXQPsB5EbkNn1PJ78cKGyirY";// Replace with your API key
  final GenerativeModel model = GenerativeModel(model: "gemini-2.0-flash", apiKey: apiKey);

  Future<String> getRemedyDetails(String remedy, String gender, int age, String severity) async {
    try {
      final String prompt = """
        Provide detailed preparation steps for $remedy considering:
        - Gender: $gender
        - Age: $age years
        - Severity level: $severity
        Also, explain how to use it properly.
      """;

      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? "No information found.";
    } catch (e) {
      return "Error: ${e.toString()}";  // Handle API errors
    }
  }

  Future<String> getYogaDetails(String yoga, String gender, int age, String severity) async {
    try {
      final String prompt = """
        Provide a step-by-step guide on how to do $yoga, considering:
        - Gender: $gender
        - Age: $age years
        - Severity level: $severity
        Include benefits and recommended yoga sessions.
      """;

      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? "No details found.";
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }
}
