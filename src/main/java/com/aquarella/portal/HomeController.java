package com.aquarella.portal;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HomeController {

	@GetMapping({"/", "/index"})
	public String getIndex(Model model){
		return "index";
	}
 
	@GetMapping({"/saldo"})
	public String getSaldo(Model model, @RequestParam String userid){
		if("666".equals(userid)) {
			model.addAttribute("nombre", "Bill Gates");
			model.addAttribute("saldo", "$96.500.000.000");
		} else {
			model.addAttribute("nombre", "Perico de los Palotes");
			model.addAttribute("saldo", "$5000");
		}
		return "saldo";
	}
}
