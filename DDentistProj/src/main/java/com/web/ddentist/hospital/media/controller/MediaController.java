package com.web.ddentist.hospital.media.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.web.ddentist.hospital.media.service.MediaService;
import com.web.ddentist.vo.CheckupVO;
import com.web.ddentist.vo.MediaVO;

import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnailator;

@Slf4j
@RequestMapping("/hospital/media")
@Controller
public class MediaController {

	@Autowired
	MediaService mediaService;
	
	/**
	 * 영상 페이지
	 * @return
	 */
	@GetMapping("")
	public String cal() {
		return "hospital/media";
	}
	
	/**
	 * 영상 편집 클릭시 캔버스 창
	 * @return
	 */
	@GetMapping("/canvas")
	public String canvas() {
		return "/hospital/canvas";
	}

	/**
	 * 환자이름과 날짜를 통해 검색한 진료내역 조회
	 * @param ptMap 검색 이름, 시작 날짜, 종료 날짜
	 * @return 진료내역 List
	 */
	@ResponseBody
	@PostMapping("/ptInfo")
	public List<CheckupVO> ptInfo(@RequestBody Map<String, String> ptMap) {
		return this.mediaService.checkUpList(ptMap);
	}

	
	/**
	 * 환자의 진료기록 선택 시 해당 진료에 대한 이미지 불러오기
	 * @param mediaMap 진료내역 PK, 시작 날짜, 끝 날짜
	 * @return
	 */
	@ResponseBody
	@PostMapping("/mediaInfo")
	public List<MediaVO> mediaInfo(@RequestBody Map<String, String> mediaMap) {
		return this.mediaService.mediaInfo(mediaMap);
	}
	
	/**
	 * 진료 내역의 이미지 삭제
	 * @param deleteMap 이미지 경로 List
	 * @return 실패시 0, 성공시 삭제된 영상의 수
	 */
	@ResponseBody
	@PostMapping("/imgDelete")
	public int imgDelete(@RequestBody Map<String, List<String>> deleteMap) {
		log.info("deleteMap : " + deleteMap);
		/*
		// 컴퓨터의 /resources 전 경로까지 필요
//		String Compath = "D:\\A_TeachingMaterial\\09_FinalPoject\\eGovFinal\\workspace\\DDentistProj\\src\\main\\webapp";
		String Compath = System.getProperty("user.dir").replace("\\eclipse", "") + "\\workspace\\DDentistProj\\src\\main\\webapp";

//		//현재 게시판에 존재하는 파일객체를 만듬
		for(String thumbPath : deleteMap.get("imgSrcArray")) {
//			thumbPath = thumbPath.split("localhost")[1];
			thumbPath = thumbPath.substring(thumbPath.indexOf("/resources/upload"));
			log.info("thumbPath : " + thumbPath);
			File thumbFile = new File(Compath, thumbPath);

			String[] path = thumbPath.split("s_");
			File file = new File(Compath, path[0] + path[1]);
			log.info("path[0] + path[1] : " + path[0] + path[1]);

			if(thumbFile.exists()) { // 파일이 존재하면
				thumbFile.delete(); // 파일 삭제
			}
			if(file.exists()) { // 파일이 존재하면
				file.delete(); // 파일 삭제
			}
		}
		*/
		List<MediaVO> mediaList = this.mediaService.getMediaList(deleteMap.get("imgNumArray"));
		// 파일 이미지 경로
		String basePath = System.getProperty("user.dir").replace("\\eclipse", "")
							+ "\\workspace\\DDentistProj\\src\\main\\webapp\\resources\\upload";
		// 파일 이미지 경로
		for(MediaVO mediaVO : mediaList) {
			Path filePath = Paths.get(basePath, mediaVO.getMedSavePath());
			Path thumbPath = Paths.get(basePath, mediaVO.getMedThumbPath());

			try {
				Files.deleteIfExists(filePath);
				Files.deleteIfExists(thumbPath);
			} catch (Exception e) {
				e.printStackTrace();
			}

		}

		List<String> medNumList = deleteMap.get("imgNumArray");
		return this.mediaService.imgDelete(medNumList);
	}

	
	/**
	 * 진료내역에 대한 영상 업로드
	 * @param uploadFile 업로드 할 이미지들
	 * @param chkNum 진료내역 PK
	 * @param ptNum 환자번호(차트번호)
	 * @param medType 영상 타입(CT or X-ray)
	 * @return 성공 시 1, 실패 시 0 반환 
	 */
	@ResponseBody
	@PostMapping("/uploadFile")
	public int uploadFile(@RequestParam(value = "image") MultipartFile[] uploadFile,
				@RequestParam(value = "chkNum") String chkNum,
				@RequestParam(value = "ptNum") String ptNum,
				@RequestParam(value = "medType") String medType) {
		//@requestParam Map<String, String> map
		log.info("chkNum : " + chkNum);
		log.info("ptNum : " + ptNum);
		System.out.println(uploadFile);
		log.info("image : {}", Arrays.toString(uploadFile));
		log.info("file count : {}", uploadFile.length);

		int result = 0; // 결과 값

		// 파일이 저장되는 경로
//		String uploadFolder = "c:\\upload";
//		String uploadFolder = "D:\\A_TeachingMaterial\\09_FinalPoject\\eGovFinal\\workspace\\DDentistProj\\src\\main\\webapp\\resources\\upload";
		String uploadFolder = System.getProperty("user.dir").replace("\\eclipse", "") + "\\workspace\\DDentistProj\\src\\main\\webapp\\resources\\upload";

		// make folder 시작-------------------------------------------
		File uploadPath = new File(uploadFolder, getFolder(ptNum));
		// 만약 연/월/일 해당 폴더가 없다면 생성
		if (uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		// make folder 끝-------------------------------------------------------------

		List<MediaVO> mediaList = new ArrayList<MediaVO>();

		String uploadFileName = "";
		for (MultipartFile multipartfile : uploadFile) {
			MediaVO mediaVO = new MediaVO();
			mediaVO.setChkNum(chkNum);
			mediaVO.setPtNum(ptNum);
			mediaVO.setMedType(medType);

			uploadFileName = multipartfile.getOriginalFilename();

			log.info("-----------------");
			log.info("이미지 명 : " + multipartfile.getOriginalFilename());
			log.info("파일 크기 : " + multipartfile.getSize());
			log.info("컨텐츠(MIME)타입 : " + multipartfile.getContentType());
			log.info("-----------------");

			// ---------파일명 중복 방지 시작 -------------
			// java.util.UUID => 랜덤값을 생성
			UUID uuid = UUID.randomUUID();
			// ERASDFERASDFA_개똥이.jpg
			uploadFileName = uuid.toString() + "_" + uploadFileName;
			// ---------파일명 중복 방지 끝 -------------

			File saveFile = new File(uploadPath, uploadFileName);
			try {
				multipartfile.transferTo(saveFile);
				// 이미지인지 체킹
				FileOutputStream thumbanil = null;
				try {
					// MIME 타입을 가져옴. images/jpeg
					String contentType = Files.probeContentType(saveFile.toPath());
					log.info("contentType : " + contentType);
					// MIME 타입 정보가 images로 시작하는지 여부
					if (contentType.startsWith("image")) {
						// 파일이름앞에 s_를 붙인다
						thumbanil = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
						// 썸네일 생성 , 100,100으로 사이즈 조절
						Thumbnailator.createThumbnail(multipartfile.getInputStream(), thumbanil, 100, 100);
						thumbanil.close();
					}

				} catch (IOException e) {
					e.printStackTrace();
					if(thumbanil != null) try { thumbanil.close(); } catch (IOException e1) {e1.printStackTrace();}
				}
			} catch (IllegalStateException e) {
				log.error(e.getMessage());
			} catch (IOException e) {
				log.error(e.getMessage());
			}

			String medSavePath = "/" + getFolder(ptNum).replace("\\", "/") + "/" + uploadFileName;
			String medThumbPath = "/" + getFolder(ptNum).replace("\\", "/") + "/s_" + uploadFileName;
			mediaVO.setMedSavePath(medSavePath);
			mediaVO.setMedThumbPath(medThumbPath);
			mediaList.add(mediaVO);
		}

		for(MediaVO vo : mediaList) { // 다중 저장 쓸 줄 몰라욤... 알려주세욤...
			result += this.mediaService.createMedia(vo);
		}

		return result;
	}

	
	/**
	 * 연 월일 폴더 경로 생성
	 * @param ptNum 환자번호(차트번호)
	 * @return 연월일 + 차트번호 -> 폴더 경로
	 */
	public static String getFolder(String ptNum) {
	  //2023-01-27 형식(format)지정
	  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	  //날짜 객체 생성(java.util 패키지)
	  Date date = new Date();
	  //2023-01-27
	  String str = sdf.format(date) + "-" + ptNum;
	  //단순 날짜 문자를 File객체의 폴더 타입으로 바꾸기
	  //c:\\upload\\2023\\01\\27
	  return str.replace("-", File.separator);
	}
	
	/**
	 * 해당 파일이 이미지인지 확인
	 * @param file 확인할 파일
	 * @return 이미지타입일 경우 true, 그 외 false 반환
	 */
	public static boolean checkImageType(File file) {
		/*
		.jpeg / .jpg(JPEG 이미지)의 MIME 타입 : image/jpeg
		*/
		//MIME 타입을 통해 이미지 여부 확인
		try {
			//file.toPath() : 파일 객체를 path객체로 변환
			String contentType = Files.probeContentType(file.toPath());
			log.info("contentType : "  + contentType);
			// MIME 타입 정보가 image로 시작하는지 엽를 return
			return contentType.startsWith("image");
		} catch (IOException e) {
			log.info(e.getMessage());
		}
		//이 파일이 이미지가 아닐 경우
		return false;
	}

}