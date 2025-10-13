package com.istiaq.daycare.service;

import com.istiaq.daycare.dto.LocationDTO;
import com.istiaq.daycare.entity.Location;
import com.istiaq.daycare.repository.ILocationRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class LocationService {

    @Autowired
    private ILocationRepo locationRepo;


    public List<LocationDTO> getAllLocations() {
        return locationRepo.findAll()
                .stream()
                .map(loc -> new LocationDTO(loc.getId(), loc.getName()))
                .collect(Collectors.toList());
    }

    public Optional<LocationDTO> getLocationById(Long id) {
        return locationRepo.findById(id)
                .map(loc -> new LocationDTO(loc.getId(), loc.getName()));
    }

    public Location createLocation(Location location) {
        return locationRepo.save(location);
    }

    public Optional<Location> updateLocation(Long id, Location updatedLocation) {
        return locationRepo.findById(id).map(location -> {
            location.setName(updatedLocation.getName());
            return locationRepo.save(location);
        });
    }

    public void deleteLocation(Long id) {
        locationRepo.deleteById(id);
    }
}
