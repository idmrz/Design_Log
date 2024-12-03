package com.basiclogin.loginsystem.Controller;
import java.io.File;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.core.io.Resource;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
// import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import com.basiclogin.loginsystem.Entity.JwtTokenUtil;
import com.basiclogin.loginsystem.Entity.User;
import com.basiclogin.loginsystem.Entity.UserInfoDto;
import com.basiclogin.loginsystem.Entity.UserListDto;
import com.basiclogin.loginsystem.Service.UserService;
import com.basiclogin.loginsystem.Service.UserServiceImpl.UsernameNotChangedException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import jakarta.servlet.http.HttpSession;
//design part

import com.basiclogin.loginsystem.DesignLogEntity.Letter;
import com.basiclogin.loginsystem.DesignLogEntity.Pdesign;
import com.basiclogin.loginsystem.DesignLogEntity.WD;
import com.basiclogin.loginsystem.DesignServices.DesignService;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;

// import org.springframework.core.io.Resource;
// import org.springframework.http.HttpHeaders;

import java.nio.file.Path;
import java.nio.file.Paths;



@CrossOrigin
@RestController
@RequestMapping("/api")
public class Controller {

   
    public final UserService userService;
    public final DesignService designService;
    // private final String fileBasePath = "D:/code_java/uploads/";
   

    public Controller(UserService userService, DesignService designService) {
        this.userService = userService;
        this.designService = designService;
        
    }

     @GetMapping("/register")
    public ResponseEntity<Void> registerUser() {
        return ResponseEntity.ok().build();
    }


     // Endpoint to return authenticated user data
     @GetMapping("/user")
     public ResponseEntity<User> getUserData() {
         // Retrieve the current authenticated user from the security context
         Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
         
         // Check if the user is authenticated and is of type User
         if (authentication != null && authentication.getPrincipal() instanceof User) {
             User user = (User) authentication.getPrincipal();
             
             // Return the user object with the relevant details (you can customize the user object fields if needed)
             return ResponseEntity.ok(user);
         } else {
             // If no authenticated user is found, return 401 Unauthorized
             return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
         }
     }


     @PostMapping("/register/user")
     public ResponseEntity<Void> createUser(@RequestBody User user) {
         userService.registerUser(user.getUserName(), user.getPassword(), user.getRole());
         return ResponseEntity.ok().build();
     }


    @DeleteMapping("/deleteUser/{userName}")
    public ResponseEntity<Void> deleteUser(@PathVariable String userName) {
        try {
            userService.deleteUser(userName);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @PutMapping("/updatePassword/{userName}")
    public ResponseEntity<Void> updateUserPassword(@PathVariable String userName,
            @RequestBody PasswordChangeRequest request) {
        try {
            userService.updateUserPassword(userName, request.getCurrentPassword(), request.getNewPassword());
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(null);
        }
    }

    @PutMapping("/updateUsername/{userId}")
    public ResponseEntity<String> updateUsername(@PathVariable Integer userId,
            @RequestBody UpdateUserNameRequest request) {
        try {
            boolean success = userService.updateUserName(userId, request.getNewUserName());
            if (success) {
                String message = "Username updated successfully.";
                return ResponseEntity.ok().body(message);
            } else {
                LocalDateTime nextChangeTime = LocalDateTime.now().plusMinutes(1);
                return ResponseEntity.ok().body("Cannot change username yet. You can change your username again after "
                        + nextChangeTime.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
            }
        } catch (UsernameNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @ExceptionHandler(UsernameNotChangedException.class)
    public ResponseEntity<String> handleUsernameNotChangedException(UsernameNotChangedException ex) {
        return ResponseEntity.status(HttpStatus.OK).body(ex.getMessage());
    }

    @GetMapping("/users")
    public ResponseEntity<List<UserListDto>> getAllUsers() {
        List<UserListDto> userListDto = userService.findAllUsers();
        return ResponseEntity.ok().body(userListDto);
    }


    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody User user, HttpSession session) {
        // Optional kullanarak kullanıcıyı buluyoruz
        Optional<User> optionalUser = userService.findByUserName(user.getUserName());
    
        if (optionalUser.isPresent()) {
            User authenticatedUser = optionalUser.get();  // Optional'dan User nesnesini alıyoruz
    
            // Kullanıcının kimlik bilgilerini doğruluyoruz
            boolean isAuthenticated = userService.authenticateUser(authenticatedUser.getUserName(), user.getPassword());
    
            if (!isAuthenticated) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid credentials");
            }
    
            // Kullanıcı doğrulandıktan sonra userId'yi alıyoruz
            Integer userId = authenticatedUser.getUserId();  // Kullanıcının userId'si
    
            // JWT token oluşturuyoruz (username ve userId ile birlikte)
            String token = JwtTokenUtil.generateToken(authenticatedUser.getUserName(), userId);
    
            return ResponseEntity.ok(token);
        } else {
            // Eğer kullanıcı bulunamazsa, hata döndür
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        }
    }
    

    @PostMapping("/{userName}/info")
    public ResponseEntity<String> saveUserInfo(
            @PathVariable String userName,
            @RequestBody UserInfoDto userInfoDto) {
        userService.saveUserInfo(userName, userInfoDto);
        return ResponseEntity.ok("User info saved successfully");
    }

    @ExceptionHandler(IllegalStateException.class)
    public ResponseEntity<String> handleIllegalStateException(IllegalStateException ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
    }

    @PatchMapping("/{userName}/info")
    public ResponseEntity<String> patchUserInfo(
            @PathVariable String userName,
            @RequestBody UserInfoDto updates) {
        userService.patchUserInfo(userName, updates);
        return ResponseEntity.ok("User info updated successfully");
    }

    @GetMapping("/{userName}/info")
    public ResponseEntity<UserInfoDto> getUserInfo(@PathVariable String userName) {
        UserInfoDto userInfoDto = userService.getUserInfo(userName);
        if (userInfoDto != null) {
            return ResponseEntity.ok(userInfoDto);
        } else {
            return ResponseEntity.notFound().build();
        }
    }


//Design part


        // 1. Get Latest Methods
        @GetMapping("/latest/wds")
        public ResponseEntity<List<WD>> getLatestWds() {
            List<WD> latestWds = designService.getLatestWds();
            return ResponseEntity.ok(latestWds);
        }
    
        @GetMapping("/latest/pds")
        public ResponseEntity<List<Pdesign>> getLatestPds() {
            List<Pdesign> latestPds = designService.getLatestPds();
            return ResponseEntity.ok(latestPds);
        }
    
        @GetMapping("/latest/lts")
        public ResponseEntity<List<Letter>> getLatestLTs() {
            List<Letter> latestLTs = designService.getLatestLTs();
            return ResponseEntity.ok(latestLTs);
        }
    
    
        // 2. Find by Identifier
        @GetMapping("/find/{identifier}")
        public <T> ResponseEntity<T> findByIdentifier(@PathVariable String identifier, @RequestParam Class<T> type) {
            T entity = designService.findByIdentifier(identifier, type);
            return ResponseEntity.ok(entity);
        }
    



    //CRUD WD
    @PostMapping("/register/wd")
    public ResponseEntity<String> createWD(
            @RequestPart("wd") String wdJson, // JSON String olarak alıyoruz
            @RequestPart(value = "files", required = false) List<MultipartFile> files,
            @RequestHeader("Authorization") String tokenHeader) {
                
    
        try {
            // WD JSON verisini Java nesnesine dönüştür
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.registerModule(new JavaTimeModule());
            WD wd = objectMapper.readValue(wdJson, WD.class);
                System.out.println("Parsed WD Object: " + wd);

                designService.registerWD(wd);
            // KKS, versionNo, revisionNo ve tarih ile klasör adı oluştur
            String rootDir = "/var/design/wdocumentation";
            String folderName = String.format("%s_%s_%s", wd.getWdId(), wd.getKks(), LocalDate.now());
            String uploadDir = rootDir + File.separator + folderName;
    
            // Klasör varsa hata döndür
            File directory = new File(uploadDir);
            if (directory.exists()) {
                return ResponseEntity.badRequest().body("Bu kombinasyonda zaten bir klasör var.");
            } else {
                directory.mkdirs(); // Klasörü oluştur
            }
    
            // Dosyaları klasöre kaydet
            if (files != null && !files.isEmpty()) {
                for (MultipartFile file : files) {
                    String originalFilename = file.getOriginalFilename();
                    String filePath = uploadDir + File.separator + originalFilename;
                    File dest = new File(filePath);
                    file.transferTo(dest); // Dosyayı kaydet
                }
            }
    
                // WD kaydına klasör yolunu ekle
                wd.setFilePath(folderName);
            
            // Token'dan userId'yi alıyoruz
            String token = tokenHeader.replace("Bearer ", "");
            Integer userId = JwtTokenUtil.getUserIdFromToken(token);
            if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }
    
            // WD kaydına userId ekliyoruz
            wd.setUserId(userId);
            // Güncellenmiş WD kaydını tekrar kaydet
            designService.registerWD(wd);

            
            return ResponseEntity.ok().build();
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    @PutMapping("/update/wd/{wdId}")
    public ResponseEntity<Void> updateWD(@PathVariable Integer wdId, @RequestBody WD updatedWD) {
        designService.updateWD(wdId, updatedWD);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/delete/wd/{wdId}")
    public ResponseEntity<Void> deleteWD(@PathVariable Integer wdId) {
        designService.deleteWD(wdId);
        return ResponseEntity.ok().build();
    }


    @PostMapping("/register/pd")
    public ResponseEntity<String> createPD(
            @RequestPart("pd") String pdJson, // JSON String olarak alıyoruz
            @RequestPart(value = "files", required = false) List<MultipartFile> files,
            @RequestHeader("Authorization") String tokenHeader) {
                
    
        try {
            // PD JSON verisini Java nesnesine dönüştür
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.registerModule(new JavaTimeModule());
            Pdesign pd = objectMapper.readValue(pdJson, Pdesign.class);
                System.out.println("Parsed PD Object: " + pd);

                designService.registerPD(pd);
            // pdId, KKS, ve tarih ile klasör adı oluştur
            String rootDir = "/var/design/pdesign";
            String folderName = String.format("%s_%s_%s", pd.getPdId(), pd.getKks(), LocalDate.now());
            String uploadDir = rootDir + File.separator + folderName;
    
            // Klasör varsa hata döndür
            File directory = new File(uploadDir);
            if (directory.exists()) {
                return ResponseEntity.badRequest().body("Bu kombinasyonda zaten bir klasör var.");
            } else {
                directory.mkdirs(); // Klasörü oluştur
            }
    
            // Dosyaları klasöre kaydet
            if (files != null && !files.isEmpty()) {
                for (MultipartFile file : files) {
                    String originalFilename = file.getOriginalFilename();
                    String filePath = uploadDir + File.separator + originalFilename;
                    File dest = new File(filePath);
                    file.transferTo(dest); // Dosyayı kaydet
                }
            }
    
                // PD kaydına klasör yolunu ekle
                pd.setFilePath(folderName);
            
            // Token'dan userId'yi alıyoruz
            String token = tokenHeader.replace("Bearer ", "");
            Integer userId = JwtTokenUtil.getUserIdFromToken(token);
            if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }
    
            // WD kaydına userId ekliyoruz
            pd.setUserId(userId);
            //guncel pd kaydi tekrar kaydediliyor
            designService.registerPD(pd);

    
            return ResponseEntity.ok().build();
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PutMapping("/update/pd/{pdId}")
    public ResponseEntity<Void> updatePD(@PathVariable Integer pdId, @RequestBody Pdesign updatedPD) {
        designService.updatePD(pdId, updatedPD);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/delete/pd/{pdId}")
    public ResponseEntity<Void> deletePD(@PathVariable Integer pdId) {
        designService.deletePD(pdId);
        return ResponseEntity.ok().build();
    }



    @PostMapping("/register/lt")
    public ResponseEntity<String> createLT(
            @RequestPart("lt") String ltJson, // JSON String olarak alıyoruz
            @RequestPart(value = "files", required = false) List<MultipartFile> files,
            @RequestHeader("Authorization") String tokenHeader) {
                
    
        try {
            // LT JSON verisini Java nesnesine dönüştür
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.registerModule(new JavaTimeModule());
            Letter lt = objectMapper.readValue(ltJson, Letter.class);
                System.out.println("Parsed LT Object: " + lt);
                
                designService.registerLetter(lt);
            // letterNo, letterDate ve category ile klasör adı oluştur
            String rootDir = "/var/design/letters";
            String folderName = String.format("%s_%s_%s", lt.getLetterId(), lt.getLetterNo(), lt.getLetterDate());
            String uploadDir = rootDir + File.separator + folderName;
    
            // Klasör varsa hata döndür
            File directory = new File(uploadDir);
            if (directory.exists()) {
                return ResponseEntity.badRequest().body("Bu kombinasyonda zaten bir klasör var.");
            } else {
                directory.mkdirs(); // Klasörü oluştur
            }
    
            // Dosyaları klasöre kaydet
            if (files != null && !files.isEmpty()) {
                for (MultipartFile file : files) {
                    String originalFilename = file.getOriginalFilename();
                    String filePath = uploadDir + File.separator + originalFilename;
                    File dest = new File(filePath);
                    file.transferTo(dest); // Dosyayı kaydet
                }
            }
    
                // LT kaydına klasör yolunu ekle
                lt.setFilePath(folderName);
            
            // Token'dan userId'yi alıyoruz
            String token = tokenHeader.replace("Bearer ", "");
            Integer userId = JwtTokenUtil.getUserIdFromToken(token);
            if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }
    
            // LT kaydına userId ekliyoruz
            lt.setUserId(userId);
            //guncel lt kaydi tekrar kaydediliyor
            designService.registerLetter(lt);
    
            return ResponseEntity.ok().build();
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }


    @PutMapping("/update/letter/{letterId}")
    public ResponseEntity<Void> updateLT(@PathVariable Integer letterId, @RequestBody Letter updatedLt) {
        designService.updateLT(letterId, updatedLt);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/delete/letter/{letterId}")
    public ResponseEntity<Void> deleteLT(@PathVariable Integer letterId) {
        designService.deleteLT(letterId);
        return ResponseEntity.ok().build();
    }

/////////////////////
@GetMapping("/folders/list")
public ResponseEntity<List<String>> listFolders(@RequestParam String type) {
    String rootDir;
    switch (type) {
        case "letter":
            rootDir = "/var/design/letters";
            break;
        case "pdesign":
            rootDir = "/var/design/pdesign";
            break;
        case "wd":
            rootDir = "/var/design/wdocumentation";
            break;
        default:
            return ResponseEntity.badRequest().body(Collections.emptyList());
    }

    File rootDirectory = new File(rootDir);
    if (!rootDirectory.exists() || !rootDirectory.isDirectory()) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Collections.emptyList());
    }

    List<String> folders = Arrays.stream(rootDirectory.listFiles())
            .filter(File::isDirectory)
            .map(File::getName)
            .collect(Collectors.toList());

    return ResponseEntity.ok(folders);
}
///////////

@GetMapping("/folders/contents")
public ResponseEntity<List<String>> listFolderContents(@RequestParam String type, @RequestParam String folderName) {
    String rootDir;
    switch (type) {
        case "letter":
            rootDir = "/var/design/letters";
            break;
        case "pdesign":
            rootDir = "/var/design/pdesign";
            break;
        case "wd":
            rootDir = "/var/design/wdocumentation";
            break;
        default:
            return ResponseEntity.badRequest().body(Collections.emptyList());
    }

    File folder = new File(rootDir + File.separator + folderName);
    if (!folder.exists() || !folder.isDirectory()) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Collections.emptyList());
    }

    List<String> contents = Arrays.stream(folder.listFiles())
            .map(file -> file.isDirectory() ? file.getName() + "/" : file.getName())
            .collect(Collectors.toList());

    return ResponseEntity.ok(contents);
}

/////////////////////
@GetMapping("/folders/download")
public ResponseEntity<Resource> downloadFile(@RequestParam String type, @RequestParam String folderName, @RequestParam String fileName) {
    String rootDir;
    switch (type) {
        case "letter":
            rootDir = "/var/design/letters";
            break;
        case "pdesign":
            rootDir = "/var/design/pdesign";
            break;
        case "wd":
            rootDir = "/var/design/wdocumentation";
            break;
        default:
            return ResponseEntity.badRequest().build();
    }

    Path filePath = Paths.get(rootDir + File.separator + folderName + File.separator + fileName);
    if (!Files.exists(filePath)) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }

    try {
        Resource resource = new UrlResource(filePath.toUri());
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
                .body(resource);
    } catch (MalformedURLException e) {
        e.printStackTrace();
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
    }
}

//////////////////////
    
    @GetMapping("/files/{folderName}")
    public ResponseEntity<List<String>> listFilesInFolder(@PathVariable String folderName) {

            // Farklı türdeki dosyalar için temel yollar
        String basePathWD = "/var/design/wdocumentation";
        String basePathPD = "/var/design/pdesign";
        String basePathLT = "/var/design/letters";

        String fileBasePath;

        // folderName’e göre doğru temel yol belirlenir
        switch (folderName.toLowerCase()) {
            case "wd":
                fileBasePath = basePathWD;
                break;
            case "pd":
                fileBasePath = basePathPD;
                break;
            case "lt":
                fileBasePath = basePathLT;
                break;
            default:
                return ResponseEntity.badRequest().body(List.of("Invalid folder name."));
        }
    
        // Seçilen klasör yolunu kullanarak dosyaları listeleme
        Path folderPath = Path.of(fileBasePath).normalize();
        File folder = folderPath.toFile();
    
        // Dosya listesi oluşturma
        List<String> fileNames = new ArrayList<>();
        if (folder.exists() && folder.isDirectory()) {
            for (File file : folder.listFiles()) {
                if (file.isFile()) {
                    fileNames.add(file.getName());
                }
            }
        } else {
            return ResponseEntity.notFound().build();
        }
    
        return ResponseEntity.ok(fileNames);
    }

}



