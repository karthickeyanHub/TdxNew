public class rowjsontotext {
    public static String jsonbodytotext(string json)
    {
        String content ;
        // String jsonString = '{"id": "chatcmpl-B5fQPKdT160iCSBpnMwmvhwLR9vLF", "object": "chat.completion", "created": 1740690577, "model": "gpt-4-turbo-2024-04-09", "choices": [ { "index": 0, "message": { "role": "assistant", "content": "{\\n \\"Doctor\\": {\\n \\"Name\\": \\"Dr. Onkar Bhave\\",\\n \\"Qualifications\\": [\\"M.B.B.S.\\", \\"M.D.\\", \\"M.S.\\"],\\n \\"Registration_Number\\": \\"270988\\",\\n \\"Mobile_Number\\": \\"9893309126\\"\\n },\\n \\"Clinic\\": {\\n \\"Name\\": \\"Care Clinic\\",\\n \\"Location\\": \\"Near Axis Bank, Kothrud, Pune - 411038\\"\\n }\\n}", "refusal": null }, "logprobs": null, "finish_reason": "length" } ], "usage": { "prompt_tokens": 811, "completion_tokens": 300, "total_tokens": 1111 }, "service_tier": "default", "system_fingerprint": "fp_7c63087da1"}';
        String jsonString = json;
        // Deserialize JSON string into a generic map
        Map<String, Object> jsonMap = (Map<String, Object>) system.JSON.deserializeUntyped(jsonString);
        
        // Extract 'choices' list
        List<Object> choices = (List<Object>) jsonMap.get('choices');
        
        if (choices != null && !choices.isEmpty()) {
            // Get first choice object
            Map<String, Object> firstChoice = (Map<String, Object>) choices[0];
            
            // Extract 'message' map
            Map<String, Object> message = (Map<String, Object>) firstChoice.get('message');
            
            if (message != null && message.containsKey('content')) {
                content =   (String) message.get('content');
                
            } else {
                System.debug('Content not found');
            }
        } else {
            System.debug('No choices available');
        }
        return content;
    }
}