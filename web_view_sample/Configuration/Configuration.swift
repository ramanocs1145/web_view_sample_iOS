//
//  Configuration.swift
//  web_view_sample
//
//  Created by EXAMPLE on 23/01/25.
//

import Foundation

public class Configuration {
    public static let shared = Configuration()

    public var _baseURL: String?
    public var _apiVersion: String?
    public var _merchantKey: String?
    public var _merchantSecret: String?
    public var _environment: String?
    
    private let queue = DispatchQueue(label: "ConfigurationQueue", attributes: .concurrent)

    public var baseURL: String? {
        get {
            return queue.sync { _baseURL }
        }
        set {
            queue.async(flags: .barrier) { self._baseURL = newValue }
        }
    }
    
    public var apiVersion: String? {
        get {
            return queue.sync { _apiVersion }
        }
        set {
            queue.async(flags: .barrier) { self._apiVersion = newValue }
        }
    }
    
    public var merchantKey: String? {
        get {
            return queue.sync { _merchantKey }
        }
        set {
            queue.async(flags: .barrier) { self._merchantKey = newValue }
        }
    }
    
    public var merchantSecret: String? {
        get {
            return queue.sync { _merchantSecret }
        }
        set {
            queue.async(flags: .barrier) { self._merchantSecret = newValue }
        }
    }
    
    public var environment: String? {
        get {
            return queue.sync { _environment }
        }
        set {
            queue.async(flags: .barrier) { self._environment = newValue }
        }
    }


    private init() {
        // Set default values or load from a config file
        self.baseURL = " " //"https://api.example.com"
        self.apiVersion = " "
        self.merchantKey = " "
        self.merchantSecret = " "
        self.environment = " "
    }

    // You can also provide custom initialization if needed
    public func updateConfigurationDetails(_ baseUrl: String?,
                                           apiVersion: String?,
                                           merchantKey: String?,
                                           merchantSecret: String?,
                                           environment: String?) {
        self.baseURL = baseUrl
        self.apiVersion = apiVersion
        self.merchantKey = merchantKey
        self.merchantSecret = merchantSecret
        self.environment = environment
    }
}
