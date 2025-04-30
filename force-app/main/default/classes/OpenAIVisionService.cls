public class OpenAIVisionService{
    
    public static String analyzeImage(String fileId) {
        // Step 1: Retrieve API key from Custom Label
        String apiKey = Label.apikey;
        
        if (String.isEmpty(apiKey)) {
            System.debug('API key is missing or not set in Custom Labels.');
            return null;
        }
        
        // Step 2: Retrieve the File URL & Validate File Format
        Map<String, String> fileInfo = getFileDownloadUrl(fileId);
        if (fileInfo == null || fileInfo.get('url') == null || fileInfo.get('format') == null) {
            System.debug('File URL not found or format unsupported.');
            return 'Unsupported file format. Only PNG, JPEG, GIF, and WEBP are allowed.';
        }
        
        String fileUrl = fileInfo.get('url');
        String fileFormat = fileInfo.get('format').toLowerCase();
        
        // Step 3: Check if the file format is supported
        List<String> supportedFormats = new List<String>{'png', 'jpeg', 'jpg', 'gif', 'webp'};
            if (!supportedFormats.contains(fileFormat)) {
                System.debug('File format not supported: ' + fileFormat);
                return 'Unsupported file format. Only PNG, JPEG, GIF, and WEBP are allowed.';
            }
        
        // Step 4: Define the API endpoint
        String endpoint = 'https://api.openai.com/v1/chat/completions';
        string base4file  = filebase64service.getBase64ImageUrl(fileId);
        // Step 5: Create HTTP request
        HTTP http = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        
        // Set Headers
        req.setHeader('Authorization', 'Bearer ' + apiKey);
        req.setHeader('Content-Type', 'application/json');
        req.setTimeout(60000);
        
        // Step 6: Construct JSON request payload
        Map<String, Object> requestBody = new Map<String, Object>{
            'model' => 'gpt-4-turbo',
                'messages' => new List<Object>{
                    new Map<String, Object>{
                        'role' => 'user',
                            'content' => new List<Object>{
                                new Map<String, Object>{ 'type' => 'text', 'text' => 'extract data from this  floor plan and return it strictly as json' },
                                    new Map<String, Object>{
                                        'type' => 'image_url',
                                            'image_url' => new Map<String, Object>{ 'url' => 'data:image/png;base64,'+ base4file }
                                    }
                            }
                    }
                },
                    'max_tokens' => 300
                    };
                        
                        // Serialize JSON and set body
                        req.setBody(JSON.serialize(requestBody));
        
        try {
            // Step 7: Make the API Callout
            HTTPResponse res = http.send(req);
            
            // Step 8: Handle Response
            if (res.getStatusCode() == 200) {
                
                // VisionApiDataParser.summarizeContent(string.valueof(res.getBody())); 
                string jsonstr = string.valueof(res.getBody());
                rowjsontotext.jsonbodytotext(jsonstr);
                System.debug('content: ' +  rowjsontotext.jsonbodytotext(jsonstr));
                return rowjsontotext.jsonbodytotext(jsonstr);
                // return 'called vision';
            } else {
                System.debug('Request failed with status code: ' + res.getStatusCode());
                System.debug('Response body: ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug('Error occurred: ' + e.getMessage());
        }
        
        return null;
    }
    
    // Helper Method: Get File URL and Format from Salesforce ContentDocument
    public static Map<String, String> getFileDownloadUrl(String fileId) {
        try {
            ContentVersion fileRecord = [
                SELECT ContentDocumentId, Title, FileExtension
                FROM ContentVersion
                WHERE ContentDocumentId = :fileId
                ORDER BY CreatedDate DESC
                LIMIT 1
            ];
            
            if (fileRecord != null) {
                // Get the correct Salesforce Base URL
                String baseUrl = System.Url.getOrgDomainUrl().toExternalForm();
                String fileUrl = baseUrl + '/sfc/servlet.shepherd/document/download/' + fileRecord.ContentDocumentId;
                
                // Return file URL and format
                return new Map<String, String>{
                    'url' => fileUrl,
                        'format' => fileRecord.FileExtension
                        };
                            }
        } catch (Exception e) {
            System.debug('Error retrieving file URL: ' + e.getMessage());
        }
        
        return null;
    }
}