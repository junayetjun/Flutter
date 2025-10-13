package com.istiaq.daycare.security;

import com.istiaq.daycare.jwt.JwtAuthenticationFilter;
import com.istiaq.daycare.jwt.JwtService;
import com.istiaq.daycare.service.UserService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http,
                                           JwtAuthenticationFilter jwtAuthenticationFilter,
                                           UserService userService) throws Exception {

        return http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(Customizer.withDefaults())
                .authorizeHttpRequests(req -> req
                                .requestMatchers("/api/locations/**", "/api/categories/**", "/api/jobs/**").permitAll()
//                        .requestMatchers(HttpMethod.GET, "/api/applications/**").permitAll()
//                        .requestMatchers(HttpMethod.POST, "/api/applications/").permitAll()
                                .requestMatchers(HttpMethod.POST, "/api/jobs/").hasRole("PARENT")
                                .requestMatchers("/api/user/login",
                                        "/auth/login",
                                        "/api/caregiver/**",
                                        "/api/education/**",
                                        "/images/**",
                                        "/api/skill/**",
                                        "/api/experience/**",
                                        "/api/hobby/**",
                                        "/api/extracurricular/**",
                                        "/api/language/**",
                                        "/api/refference/**",
                                        "/api/training/**",
                                        "/api/user/active/**",
                                        "/api/parent/",
                                        "/api/parent/**",
                                        "/api/admin/",
                                        "/api/admin/**",
                                        "/api/categories/",
                                        "/api/categories/**",
                                        "/api/locations/**",
                                        "/api/locations/",
                                        "/api/contact/",
                                        "/api/jobs/search**",
                                        "/api/contact/**",
                                        "/api/cv/view/by-user/**",
                                        "/api/jobs/my-jobs"
                                ).permitAll()
                                .requestMatchers("/api/user/all",
                                        "/api/caregiver/profile",
                                        "/api/education/add",
                                        "/api/education/all",
                                        "/api/experience/add",
                                        "/api/experience/all",
                                        "/api/extracurricular/add",
                                        "/api/extracurricular/all",
                                        "/api/hobby/add",
                                        "/api/hobby/all",
                                        "/api/language/add",
                                        "/api/language/all",
                                        "/api/refference/add",
                                        "/api/refference/all",
                                        "/api/skill/add",
                                        "/api/skill/all",
                                        "/api/training/add",
                                        "/api/training/all",
                                        "/api/applications/apply",
                                        "/api/applications/my"
                                ).hasRole("CAREGIVER")
                                .requestMatchers("/api/parent/profile",
                                        "/api/jobs/**",
                                        "/api/applications/applicant/"
                                ).hasRole("PARENT")
                                .anyRequest().authenticated()
                )
                .userDetailsService(userService)
                .sessionManagement(session ->
                        session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    public JwtAuthenticationFilter jwtAuthenticationFilter(JwtService jwtService, UserService userService) {
        return new JwtAuthenticationFilter(jwtService, userService);
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder encoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(List.of("http://localhost:4200", "http://127.0.0.1:4200"));
        configuration.setAllowedMethods(List.of("GET", "POST", "DELETE", "PUT", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("Authorization", "Cache-Control", "Content-Type"));
        configuration.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
