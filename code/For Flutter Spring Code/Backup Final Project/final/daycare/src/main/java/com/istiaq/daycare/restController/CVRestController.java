package com.istiaq.daycare.restController;

import com.istiaq.daycare.service.CVService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/cv")
public class CVRestController {

//    @Autowired
//    private CVService cvService;
//
//    @GetMapping("/download/{caregiverId}")
//    public ResponseEntity<byte[]> downloadCV(@PathVariable Long caregiverId) {
//        try {
//            byte[] pdfBytes = cvService.generateCV(caregiverId);
//            HttpHeaders headers = new HttpHeaders();
//            headers.setContentType(MediaType.APPLICATION_PDF);
//            headers.setContentDispositionFormData("attachment", "CV_" + caregiverId + ".pdf");
//            return ResponseEntity.ok().headers(headers).body(pdfBytes);
//        } catch (Exception e) {
//            e.printStackTrace();
//            return ResponseEntity.status(500).build();
//        }
//    }
//
//
//    @GetMapping("/view/by-user/{email}")
//    public ResponseEntity<byte[]> viewCVByUser(@PathVariable String email) {
//        try {
//            byte[] pdfBytes = cvService.generateCVForUser(email);
//
//            HttpHeaders headers = new HttpHeaders();
//            headers.setContentType(MediaType.APPLICATION_PDF);
//            headers.setContentDispositionFormData("inline", "CV_User_" + email + ".pdf");
//
//            return ResponseEntity.ok()
//                    .headers(headers)
//                    .body(pdfBytes);
//        } catch (Exception e) {
//            e.printStackTrace();
//            return ResponseEntity.status(500).build();
//        }
//    }
//
//    @GetMapping("/view/{caregiverId}")
//    public ResponseEntity<byte[]> viewCV(@PathVariable Long caregiverId) {
//        try {
//            byte[] pdfBytes = cvService.generateCV(caregiverId);
//            HttpHeaders headers = new HttpHeaders();
//            headers.setContentType(MediaType.APPLICATION_PDF);
//            headers.setContentDispositionFormData("inline", "CV_" + caregiverId + ".pdf");
//            return ResponseEntity.ok().headers(headers).body(pdfBytes);
//        } catch (Exception e) {
//            e.printStackTrace();
//            return ResponseEntity.status(500).build();
//        }
//    }
}
