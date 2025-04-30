public class FileBase64Service {
    public static String getBase64ImageUrl(String fileId) {
        try {
            // Retrieve the file from ContentVersion using ContentDocumentId
            ContentVersion fileRecord = [
                SELECT VersionData, FileExtension
                FROM ContentVersion
                WHERE ContentDocumentId = :fileId
                ORDER BY CreatedDate DESC
                LIMIT 1
            ];

            if (fileRecord == null || fileRecord.VersionData == null) {
                return 'File not found or does not have data.';
            }

            // Convert Blob to Base64 String
            String base64Data = EncodingUtil.base64Encode(fileRecord.VersionData);

            // Define the correct MIME type
            String mimeType = getMimeType(fileRecord.FileExtension);

            // Construct the Base64 Image URL (Data URI)
            String base64Url =  base64Data;
            
            return base64Url;
        } catch (Exception e) {
            System.debug('Error retrieving Base64 Image URL: ' + e.getMessage());
            return null;
        }
    }

    // Helper Method to Map File Extensions to MIME Types
    public static String getMimeType(String fileExtension) {
        Map<String, String> mimeTypes = new Map<String, String>{
            'png' => 'image/png',
            'jpg' => 'image/jpeg',
            'jpeg' => 'image/jpeg',
            'gif' => 'image/gif',
            'webp' => 'image/webp'
        };
        
        return mimeTypes.containsKey(fileExtension.toLowerCase()) ? mimeTypes.get(fileExtension.toLowerCase()) : 'application/octet-stream';
    }
}