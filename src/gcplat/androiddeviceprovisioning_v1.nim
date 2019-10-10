
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Android Device Provisioning Partner
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Automates Android zero-touch enrollment for device resellers, customers, and EMMs.
## 
## https://developers.google.com/zero-touch/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "androiddeviceprovisioning"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroiddeviceprovisioningCustomersList_588710 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningCustomersList_588712(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroiddeviceprovisioningCustomersList_588711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the user's customer accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token specifying which result page to return.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of customers to show in a page of results.
  ## A number between 1 and 100 (inclusive).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("fields")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "fields", valid_588825
  var valid_588826 = query.getOrDefault("pageToken")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "pageToken", valid_588826
  var valid_588827 = query.getOrDefault("quotaUser")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "quotaUser", valid_588827
  var valid_588841 = query.getOrDefault("alt")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = newJString("json"))
  if valid_588841 != nil:
    section.add "alt", valid_588841
  var valid_588842 = query.getOrDefault("oauth_token")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "oauth_token", valid_588842
  var valid_588843 = query.getOrDefault("callback")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "callback", valid_588843
  var valid_588844 = query.getOrDefault("access_token")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "access_token", valid_588844
  var valid_588845 = query.getOrDefault("uploadType")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "uploadType", valid_588845
  var valid_588846 = query.getOrDefault("key")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "key", valid_588846
  var valid_588847 = query.getOrDefault("$.xgafv")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = newJString("1"))
  if valid_588847 != nil:
    section.add "$.xgafv", valid_588847
  var valid_588848 = query.getOrDefault("pageSize")
  valid_588848 = validateParameter(valid_588848, JInt, required = false, default = nil)
  if valid_588848 != nil:
    section.add "pageSize", valid_588848
  var valid_588849 = query.getOrDefault("prettyPrint")
  valid_588849 = validateParameter(valid_588849, JBool, required = false,
                                 default = newJBool(true))
  if valid_588849 != nil:
    section.add "prettyPrint", valid_588849
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588872: Call_AndroiddeviceprovisioningCustomersList_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the user's customer accounts.
  ## 
  let valid = call_588872.validator(path, query, header, formData, body)
  let scheme = call_588872.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588872.url(scheme.get, call_588872.host, call_588872.base,
                         call_588872.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588872, url, valid)

proc call*(call_588943: Call_AndroiddeviceprovisioningCustomersList_588710;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningCustomersList
  ## Lists the user's customer accounts.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token specifying which result page to return.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of customers to show in a page of results.
  ## A number between 1 and 100 (inclusive).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588944 = newJObject()
  add(query_588944, "upload_protocol", newJString(uploadProtocol))
  add(query_588944, "fields", newJString(fields))
  add(query_588944, "pageToken", newJString(pageToken))
  add(query_588944, "quotaUser", newJString(quotaUser))
  add(query_588944, "alt", newJString(alt))
  add(query_588944, "oauth_token", newJString(oauthToken))
  add(query_588944, "callback", newJString(callback))
  add(query_588944, "access_token", newJString(accessToken))
  add(query_588944, "uploadType", newJString(uploadType))
  add(query_588944, "key", newJString(key))
  add(query_588944, "$.xgafv", newJString(Xgafv))
  add(query_588944, "pageSize", newJInt(pageSize))
  add(query_588944, "prettyPrint", newJBool(prettyPrint))
  result = call_588943.call(nil, query_588944, nil, nil, nil)

var androiddeviceprovisioningCustomersList* = Call_AndroiddeviceprovisioningCustomersList_588710(
    name: "androiddeviceprovisioningCustomersList", meth: HttpMethod.HttpGet,
    host: "androiddeviceprovisioning.googleapis.com", route: "/v1/customers",
    validator: validate_AndroiddeviceprovisioningCustomersList_588711, base: "/",
    url: url_AndroiddeviceprovisioningCustomersList_588712,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesMetadata_588984 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningPartnersDevicesMetadata_588986(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "metadataOwnerId" in path, "`metadataOwnerId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/partners/"),
               (kind: VariableSegment, value: "metadataOwnerId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesMetadata_588985(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates reseller metadata associated with the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceId: JString (required)
  ##           : Required. The ID of the device.
  ##   metadataOwnerId: JString (required)
  ##                  : Required. The owner of the newly set metadata. Set this to the partner ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `deviceId` field"
  var valid_589001 = path.getOrDefault("deviceId")
  valid_589001 = validateParameter(valid_589001, JString, required = true,
                                 default = nil)
  if valid_589001 != nil:
    section.add "deviceId", valid_589001
  var valid_589002 = path.getOrDefault("metadataOwnerId")
  valid_589002 = validateParameter(valid_589002, JString, required = true,
                                 default = nil)
  if valid_589002 != nil:
    section.add "metadataOwnerId", valid_589002
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589003 = query.getOrDefault("upload_protocol")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "upload_protocol", valid_589003
  var valid_589004 = query.getOrDefault("fields")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "fields", valid_589004
  var valid_589005 = query.getOrDefault("quotaUser")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "quotaUser", valid_589005
  var valid_589006 = query.getOrDefault("alt")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = newJString("json"))
  if valid_589006 != nil:
    section.add "alt", valid_589006
  var valid_589007 = query.getOrDefault("oauth_token")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "oauth_token", valid_589007
  var valid_589008 = query.getOrDefault("callback")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "callback", valid_589008
  var valid_589009 = query.getOrDefault("access_token")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "access_token", valid_589009
  var valid_589010 = query.getOrDefault("uploadType")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "uploadType", valid_589010
  var valid_589011 = query.getOrDefault("key")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "key", valid_589011
  var valid_589012 = query.getOrDefault("$.xgafv")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = newJString("1"))
  if valid_589012 != nil:
    section.add "$.xgafv", valid_589012
  var valid_589013 = query.getOrDefault("prettyPrint")
  valid_589013 = validateParameter(valid_589013, JBool, required = false,
                                 default = newJBool(true))
  if valid_589013 != nil:
    section.add "prettyPrint", valid_589013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589015: Call_AndroiddeviceprovisioningPartnersDevicesMetadata_588984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates reseller metadata associated with the device.
  ## 
  let valid = call_589015.validator(path, query, header, formData, body)
  let scheme = call_589015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589015.url(scheme.get, call_589015.host, call_589015.base,
                         call_589015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589015, url, valid)

proc call*(call_589016: Call_AndroiddeviceprovisioningPartnersDevicesMetadata_588984;
          deviceId: string; metadataOwnerId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningPartnersDevicesMetadata
  ## Updates reseller metadata associated with the device.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   deviceId: string (required)
  ##           : Required. The ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   metadataOwnerId: string (required)
  ##                  : Required. The owner of the newly set metadata. Set this to the partner ID.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589017 = newJObject()
  var query_589018 = newJObject()
  var body_589019 = newJObject()
  add(query_589018, "upload_protocol", newJString(uploadProtocol))
  add(query_589018, "fields", newJString(fields))
  add(query_589018, "quotaUser", newJString(quotaUser))
  add(query_589018, "alt", newJString(alt))
  add(path_589017, "deviceId", newJString(deviceId))
  add(query_589018, "oauth_token", newJString(oauthToken))
  add(query_589018, "callback", newJString(callback))
  add(query_589018, "access_token", newJString(accessToken))
  add(query_589018, "uploadType", newJString(uploadType))
  add(query_589018, "key", newJString(key))
  add(path_589017, "metadataOwnerId", newJString(metadataOwnerId))
  add(query_589018, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589019 = body
  add(query_589018, "prettyPrint", newJBool(prettyPrint))
  result = call_589016.call(path_589017, query_589018, nil, nil, body_589019)

var androiddeviceprovisioningPartnersDevicesMetadata* = Call_AndroiddeviceprovisioningPartnersDevicesMetadata_588984(
    name: "androiddeviceprovisioningPartnersDevicesMetadata",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{metadataOwnerId}/devices/{deviceId}/metadata",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesMetadata_588985,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesMetadata_588986,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersCustomersList_589020 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningPartnersCustomersList_589022(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "partnerId" in path, "`partnerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/partners/"),
               (kind: VariableSegment, value: "partnerId"),
               (kind: ConstantSegment, value: "/customers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersCustomersList_589021(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the customers that are enrolled to the reseller identified by the
  ## `partnerId` argument. This list includes customers that the reseller
  ## created and customers that enrolled themselves using the portal.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partnerId: JString (required)
  ##            : Required. The ID of the reseller partner.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partnerId` field"
  var valid_589023 = path.getOrDefault("partnerId")
  valid_589023 = validateParameter(valid_589023, JString, required = true,
                                 default = nil)
  if valid_589023 != nil:
    section.add "partnerId", valid_589023
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results returned by the server.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of results to be returned. If not specified or 0, all
  ## the records are returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589024 = query.getOrDefault("upload_protocol")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "upload_protocol", valid_589024
  var valid_589025 = query.getOrDefault("fields")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "fields", valid_589025
  var valid_589026 = query.getOrDefault("pageToken")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "pageToken", valid_589026
  var valid_589027 = query.getOrDefault("quotaUser")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "quotaUser", valid_589027
  var valid_589028 = query.getOrDefault("alt")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = newJString("json"))
  if valid_589028 != nil:
    section.add "alt", valid_589028
  var valid_589029 = query.getOrDefault("oauth_token")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "oauth_token", valid_589029
  var valid_589030 = query.getOrDefault("callback")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "callback", valid_589030
  var valid_589031 = query.getOrDefault("access_token")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "access_token", valid_589031
  var valid_589032 = query.getOrDefault("uploadType")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "uploadType", valid_589032
  var valid_589033 = query.getOrDefault("key")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "key", valid_589033
  var valid_589034 = query.getOrDefault("$.xgafv")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = newJString("1"))
  if valid_589034 != nil:
    section.add "$.xgafv", valid_589034
  var valid_589035 = query.getOrDefault("pageSize")
  valid_589035 = validateParameter(valid_589035, JInt, required = false, default = nil)
  if valid_589035 != nil:
    section.add "pageSize", valid_589035
  var valid_589036 = query.getOrDefault("prettyPrint")
  valid_589036 = validateParameter(valid_589036, JBool, required = false,
                                 default = newJBool(true))
  if valid_589036 != nil:
    section.add "prettyPrint", valid_589036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589037: Call_AndroiddeviceprovisioningPartnersCustomersList_589020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the customers that are enrolled to the reseller identified by the
  ## `partnerId` argument. This list includes customers that the reseller
  ## created and customers that enrolled themselves using the portal.
  ## 
  let valid = call_589037.validator(path, query, header, formData, body)
  let scheme = call_589037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589037.url(scheme.get, call_589037.host, call_589037.base,
                         call_589037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589037, url, valid)

proc call*(call_589038: Call_AndroiddeviceprovisioningPartnersCustomersList_589020;
          partnerId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningPartnersCustomersList
  ## Lists the customers that are enrolled to the reseller identified by the
  ## `partnerId` argument. This list includes customers that the reseller
  ## created and customers that enrolled themselves using the portal.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results returned by the server.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to be returned. If not specified or 0, all
  ## the records are returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   partnerId: string (required)
  ##            : Required. The ID of the reseller partner.
  var path_589039 = newJObject()
  var query_589040 = newJObject()
  add(query_589040, "upload_protocol", newJString(uploadProtocol))
  add(query_589040, "fields", newJString(fields))
  add(query_589040, "pageToken", newJString(pageToken))
  add(query_589040, "quotaUser", newJString(quotaUser))
  add(query_589040, "alt", newJString(alt))
  add(query_589040, "oauth_token", newJString(oauthToken))
  add(query_589040, "callback", newJString(callback))
  add(query_589040, "access_token", newJString(accessToken))
  add(query_589040, "uploadType", newJString(uploadType))
  add(query_589040, "key", newJString(key))
  add(query_589040, "$.xgafv", newJString(Xgafv))
  add(query_589040, "pageSize", newJInt(pageSize))
  add(query_589040, "prettyPrint", newJBool(prettyPrint))
  add(path_589039, "partnerId", newJString(partnerId))
  result = call_589038.call(path_589039, query_589040, nil, nil, nil)

var androiddeviceprovisioningPartnersCustomersList* = Call_AndroiddeviceprovisioningPartnersCustomersList_589020(
    name: "androiddeviceprovisioningPartnersCustomersList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/customers",
    validator: validate_AndroiddeviceprovisioningPartnersCustomersList_589021,
    base: "/", url: url_AndroiddeviceprovisioningPartnersCustomersList_589022,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesClaim_589041 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningPartnersDevicesClaim_589043(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "partnerId" in path, "`partnerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/partners/"),
               (kind: VariableSegment, value: "partnerId"),
               (kind: ConstantSegment, value: "/devices:claim")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesClaim_589042(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Claims a device for a customer and adds it to zero-touch enrollment. If the
  ## device is already claimed by another customer, the call returns an error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partnerId: JString (required)
  ##            : Required. The ID of the reseller partner.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partnerId` field"
  var valid_589044 = path.getOrDefault("partnerId")
  valid_589044 = validateParameter(valid_589044, JString, required = true,
                                 default = nil)
  if valid_589044 != nil:
    section.add "partnerId", valid_589044
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589045 = query.getOrDefault("upload_protocol")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "upload_protocol", valid_589045
  var valid_589046 = query.getOrDefault("fields")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "fields", valid_589046
  var valid_589047 = query.getOrDefault("quotaUser")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "quotaUser", valid_589047
  var valid_589048 = query.getOrDefault("alt")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = newJString("json"))
  if valid_589048 != nil:
    section.add "alt", valid_589048
  var valid_589049 = query.getOrDefault("oauth_token")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "oauth_token", valid_589049
  var valid_589050 = query.getOrDefault("callback")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "callback", valid_589050
  var valid_589051 = query.getOrDefault("access_token")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "access_token", valid_589051
  var valid_589052 = query.getOrDefault("uploadType")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "uploadType", valid_589052
  var valid_589053 = query.getOrDefault("key")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "key", valid_589053
  var valid_589054 = query.getOrDefault("$.xgafv")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("1"))
  if valid_589054 != nil:
    section.add "$.xgafv", valid_589054
  var valid_589055 = query.getOrDefault("prettyPrint")
  valid_589055 = validateParameter(valid_589055, JBool, required = false,
                                 default = newJBool(true))
  if valid_589055 != nil:
    section.add "prettyPrint", valid_589055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589057: Call_AndroiddeviceprovisioningPartnersDevicesClaim_589041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Claims a device for a customer and adds it to zero-touch enrollment. If the
  ## device is already claimed by another customer, the call returns an error.
  ## 
  let valid = call_589057.validator(path, query, header, formData, body)
  let scheme = call_589057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589057.url(scheme.get, call_589057.host, call_589057.base,
                         call_589057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589057, url, valid)

proc call*(call_589058: Call_AndroiddeviceprovisioningPartnersDevicesClaim_589041;
          partnerId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningPartnersDevicesClaim
  ## Claims a device for a customer and adds it to zero-touch enrollment. If the
  ## device is already claimed by another customer, the call returns an error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   partnerId: string (required)
  ##            : Required. The ID of the reseller partner.
  var path_589059 = newJObject()
  var query_589060 = newJObject()
  var body_589061 = newJObject()
  add(query_589060, "upload_protocol", newJString(uploadProtocol))
  add(query_589060, "fields", newJString(fields))
  add(query_589060, "quotaUser", newJString(quotaUser))
  add(query_589060, "alt", newJString(alt))
  add(query_589060, "oauth_token", newJString(oauthToken))
  add(query_589060, "callback", newJString(callback))
  add(query_589060, "access_token", newJString(accessToken))
  add(query_589060, "uploadType", newJString(uploadType))
  add(query_589060, "key", newJString(key))
  add(query_589060, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589061 = body
  add(query_589060, "prettyPrint", newJBool(prettyPrint))
  add(path_589059, "partnerId", newJString(partnerId))
  result = call_589058.call(path_589059, query_589060, nil, nil, body_589061)

var androiddeviceprovisioningPartnersDevicesClaim* = Call_AndroiddeviceprovisioningPartnersDevicesClaim_589041(
    name: "androiddeviceprovisioningPartnersDevicesClaim",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:claim",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesClaim_589042,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesClaim_589043,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesClaimAsync_589062 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningPartnersDevicesClaimAsync_589064(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "partnerId" in path, "`partnerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/partners/"),
               (kind: VariableSegment, value: "partnerId"),
               (kind: ConstantSegment, value: "/devices:claimAsync")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesClaimAsync_589063(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Claims a batch of devices for a customer asynchronously. Adds the devices
  ## to zero-touch enrollment. To learn more, read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partnerId: JString (required)
  ##            : Required. The ID of the reseller partner.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partnerId` field"
  var valid_589065 = path.getOrDefault("partnerId")
  valid_589065 = validateParameter(valid_589065, JString, required = true,
                                 default = nil)
  if valid_589065 != nil:
    section.add "partnerId", valid_589065
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589066 = query.getOrDefault("upload_protocol")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "upload_protocol", valid_589066
  var valid_589067 = query.getOrDefault("fields")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "fields", valid_589067
  var valid_589068 = query.getOrDefault("quotaUser")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "quotaUser", valid_589068
  var valid_589069 = query.getOrDefault("alt")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = newJString("json"))
  if valid_589069 != nil:
    section.add "alt", valid_589069
  var valid_589070 = query.getOrDefault("oauth_token")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "oauth_token", valid_589070
  var valid_589071 = query.getOrDefault("callback")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "callback", valid_589071
  var valid_589072 = query.getOrDefault("access_token")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "access_token", valid_589072
  var valid_589073 = query.getOrDefault("uploadType")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "uploadType", valid_589073
  var valid_589074 = query.getOrDefault("key")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "key", valid_589074
  var valid_589075 = query.getOrDefault("$.xgafv")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("1"))
  if valid_589075 != nil:
    section.add "$.xgafv", valid_589075
  var valid_589076 = query.getOrDefault("prettyPrint")
  valid_589076 = validateParameter(valid_589076, JBool, required = false,
                                 default = newJBool(true))
  if valid_589076 != nil:
    section.add "prettyPrint", valid_589076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589078: Call_AndroiddeviceprovisioningPartnersDevicesClaimAsync_589062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Claims a batch of devices for a customer asynchronously. Adds the devices
  ## to zero-touch enrollment. To learn more, read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ## 
  let valid = call_589078.validator(path, query, header, formData, body)
  let scheme = call_589078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589078.url(scheme.get, call_589078.host, call_589078.base,
                         call_589078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589078, url, valid)

proc call*(call_589079: Call_AndroiddeviceprovisioningPartnersDevicesClaimAsync_589062;
          partnerId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningPartnersDevicesClaimAsync
  ## Claims a batch of devices for a customer asynchronously. Adds the devices
  ## to zero-touch enrollment. To learn more, read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   partnerId: string (required)
  ##            : Required. The ID of the reseller partner.
  var path_589080 = newJObject()
  var query_589081 = newJObject()
  var body_589082 = newJObject()
  add(query_589081, "upload_protocol", newJString(uploadProtocol))
  add(query_589081, "fields", newJString(fields))
  add(query_589081, "quotaUser", newJString(quotaUser))
  add(query_589081, "alt", newJString(alt))
  add(query_589081, "oauth_token", newJString(oauthToken))
  add(query_589081, "callback", newJString(callback))
  add(query_589081, "access_token", newJString(accessToken))
  add(query_589081, "uploadType", newJString(uploadType))
  add(query_589081, "key", newJString(key))
  add(query_589081, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589082 = body
  add(query_589081, "prettyPrint", newJBool(prettyPrint))
  add(path_589080, "partnerId", newJString(partnerId))
  result = call_589079.call(path_589080, query_589081, nil, nil, body_589082)

var androiddeviceprovisioningPartnersDevicesClaimAsync* = Call_AndroiddeviceprovisioningPartnersDevicesClaimAsync_589062(
    name: "androiddeviceprovisioningPartnersDevicesClaimAsync",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:claimAsync",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesClaimAsync_589063,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesClaimAsync_589064,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_589083 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_589085(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "partnerId" in path, "`partnerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/partners/"),
               (kind: VariableSegment, value: "partnerId"),
               (kind: ConstantSegment, value: "/devices:findByIdentifier")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_589084(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Finds devices by hardware identifiers, such as IMEI.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partnerId: JString (required)
  ##            : Required. The ID of the reseller partner.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partnerId` field"
  var valid_589086 = path.getOrDefault("partnerId")
  valid_589086 = validateParameter(valid_589086, JString, required = true,
                                 default = nil)
  if valid_589086 != nil:
    section.add "partnerId", valid_589086
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589087 = query.getOrDefault("upload_protocol")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "upload_protocol", valid_589087
  var valid_589088 = query.getOrDefault("fields")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "fields", valid_589088
  var valid_589089 = query.getOrDefault("quotaUser")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "quotaUser", valid_589089
  var valid_589090 = query.getOrDefault("alt")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = newJString("json"))
  if valid_589090 != nil:
    section.add "alt", valid_589090
  var valid_589091 = query.getOrDefault("oauth_token")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "oauth_token", valid_589091
  var valid_589092 = query.getOrDefault("callback")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "callback", valid_589092
  var valid_589093 = query.getOrDefault("access_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "access_token", valid_589093
  var valid_589094 = query.getOrDefault("uploadType")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "uploadType", valid_589094
  var valid_589095 = query.getOrDefault("key")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "key", valid_589095
  var valid_589096 = query.getOrDefault("$.xgafv")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = newJString("1"))
  if valid_589096 != nil:
    section.add "$.xgafv", valid_589096
  var valid_589097 = query.getOrDefault("prettyPrint")
  valid_589097 = validateParameter(valid_589097, JBool, required = false,
                                 default = newJBool(true))
  if valid_589097 != nil:
    section.add "prettyPrint", valid_589097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589099: Call_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_589083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Finds devices by hardware identifiers, such as IMEI.
  ## 
  let valid = call_589099.validator(path, query, header, formData, body)
  let scheme = call_589099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589099.url(scheme.get, call_589099.host, call_589099.base,
                         call_589099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589099, url, valid)

proc call*(call_589100: Call_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_589083;
          partnerId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningPartnersDevicesFindByIdentifier
  ## Finds devices by hardware identifiers, such as IMEI.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   partnerId: string (required)
  ##            : Required. The ID of the reseller partner.
  var path_589101 = newJObject()
  var query_589102 = newJObject()
  var body_589103 = newJObject()
  add(query_589102, "upload_protocol", newJString(uploadProtocol))
  add(query_589102, "fields", newJString(fields))
  add(query_589102, "quotaUser", newJString(quotaUser))
  add(query_589102, "alt", newJString(alt))
  add(query_589102, "oauth_token", newJString(oauthToken))
  add(query_589102, "callback", newJString(callback))
  add(query_589102, "access_token", newJString(accessToken))
  add(query_589102, "uploadType", newJString(uploadType))
  add(query_589102, "key", newJString(key))
  add(query_589102, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589103 = body
  add(query_589102, "prettyPrint", newJBool(prettyPrint))
  add(path_589101, "partnerId", newJString(partnerId))
  result = call_589100.call(path_589101, query_589102, nil, nil, body_589103)

var androiddeviceprovisioningPartnersDevicesFindByIdentifier* = Call_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_589083(
    name: "androiddeviceprovisioningPartnersDevicesFindByIdentifier",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:findByIdentifier", validator: validate_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_589084,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_589085,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesFindByOwner_589104 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningPartnersDevicesFindByOwner_589106(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "partnerId" in path, "`partnerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/partners/"),
               (kind: VariableSegment, value: "partnerId"),
               (kind: ConstantSegment, value: "/devices:findByOwner")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesFindByOwner_589105(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Finds devices claimed for customers. The results only contain devices
  ## registered to the reseller that's identified by the `partnerId` argument.
  ## The customer's devices purchased from other resellers don't appear in the
  ## results.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partnerId: JString (required)
  ##            : Required. The ID of the reseller partner.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partnerId` field"
  var valid_589107 = path.getOrDefault("partnerId")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "partnerId", valid_589107
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589108 = query.getOrDefault("upload_protocol")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "upload_protocol", valid_589108
  var valid_589109 = query.getOrDefault("fields")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "fields", valid_589109
  var valid_589110 = query.getOrDefault("quotaUser")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "quotaUser", valid_589110
  var valid_589111 = query.getOrDefault("alt")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = newJString("json"))
  if valid_589111 != nil:
    section.add "alt", valid_589111
  var valid_589112 = query.getOrDefault("oauth_token")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "oauth_token", valid_589112
  var valid_589113 = query.getOrDefault("callback")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "callback", valid_589113
  var valid_589114 = query.getOrDefault("access_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "access_token", valid_589114
  var valid_589115 = query.getOrDefault("uploadType")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "uploadType", valid_589115
  var valid_589116 = query.getOrDefault("key")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "key", valid_589116
  var valid_589117 = query.getOrDefault("$.xgafv")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = newJString("1"))
  if valid_589117 != nil:
    section.add "$.xgafv", valid_589117
  var valid_589118 = query.getOrDefault("prettyPrint")
  valid_589118 = validateParameter(valid_589118, JBool, required = false,
                                 default = newJBool(true))
  if valid_589118 != nil:
    section.add "prettyPrint", valid_589118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589120: Call_AndroiddeviceprovisioningPartnersDevicesFindByOwner_589104;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Finds devices claimed for customers. The results only contain devices
  ## registered to the reseller that's identified by the `partnerId` argument.
  ## The customer's devices purchased from other resellers don't appear in the
  ## results.
  ## 
  let valid = call_589120.validator(path, query, header, formData, body)
  let scheme = call_589120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589120.url(scheme.get, call_589120.host, call_589120.base,
                         call_589120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589120, url, valid)

proc call*(call_589121: Call_AndroiddeviceprovisioningPartnersDevicesFindByOwner_589104;
          partnerId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningPartnersDevicesFindByOwner
  ## Finds devices claimed for customers. The results only contain devices
  ## registered to the reseller that's identified by the `partnerId` argument.
  ## The customer's devices purchased from other resellers don't appear in the
  ## results.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   partnerId: string (required)
  ##            : Required. The ID of the reseller partner.
  var path_589122 = newJObject()
  var query_589123 = newJObject()
  var body_589124 = newJObject()
  add(query_589123, "upload_protocol", newJString(uploadProtocol))
  add(query_589123, "fields", newJString(fields))
  add(query_589123, "quotaUser", newJString(quotaUser))
  add(query_589123, "alt", newJString(alt))
  add(query_589123, "oauth_token", newJString(oauthToken))
  add(query_589123, "callback", newJString(callback))
  add(query_589123, "access_token", newJString(accessToken))
  add(query_589123, "uploadType", newJString(uploadType))
  add(query_589123, "key", newJString(key))
  add(query_589123, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589124 = body
  add(query_589123, "prettyPrint", newJBool(prettyPrint))
  add(path_589122, "partnerId", newJString(partnerId))
  result = call_589121.call(path_589122, query_589123, nil, nil, body_589124)

var androiddeviceprovisioningPartnersDevicesFindByOwner* = Call_AndroiddeviceprovisioningPartnersDevicesFindByOwner_589104(
    name: "androiddeviceprovisioningPartnersDevicesFindByOwner",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:findByOwner",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesFindByOwner_589105,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesFindByOwner_589106,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesUnclaim_589125 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningPartnersDevicesUnclaim_589127(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "partnerId" in path, "`partnerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/partners/"),
               (kind: VariableSegment, value: "partnerId"),
               (kind: ConstantSegment, value: "/devices:unclaim")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesUnclaim_589126(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Unclaims a device from a customer and removes it from zero-touch
  ## enrollment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partnerId: JString (required)
  ##            : Required. The ID of the reseller partner.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partnerId` field"
  var valid_589128 = path.getOrDefault("partnerId")
  valid_589128 = validateParameter(valid_589128, JString, required = true,
                                 default = nil)
  if valid_589128 != nil:
    section.add "partnerId", valid_589128
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589129 = query.getOrDefault("upload_protocol")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "upload_protocol", valid_589129
  var valid_589130 = query.getOrDefault("fields")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "fields", valid_589130
  var valid_589131 = query.getOrDefault("quotaUser")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "quotaUser", valid_589131
  var valid_589132 = query.getOrDefault("alt")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = newJString("json"))
  if valid_589132 != nil:
    section.add "alt", valid_589132
  var valid_589133 = query.getOrDefault("oauth_token")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "oauth_token", valid_589133
  var valid_589134 = query.getOrDefault("callback")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "callback", valid_589134
  var valid_589135 = query.getOrDefault("access_token")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "access_token", valid_589135
  var valid_589136 = query.getOrDefault("uploadType")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "uploadType", valid_589136
  var valid_589137 = query.getOrDefault("key")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "key", valid_589137
  var valid_589138 = query.getOrDefault("$.xgafv")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = newJString("1"))
  if valid_589138 != nil:
    section.add "$.xgafv", valid_589138
  var valid_589139 = query.getOrDefault("prettyPrint")
  valid_589139 = validateParameter(valid_589139, JBool, required = false,
                                 default = newJBool(true))
  if valid_589139 != nil:
    section.add "prettyPrint", valid_589139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589141: Call_AndroiddeviceprovisioningPartnersDevicesUnclaim_589125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unclaims a device from a customer and removes it from zero-touch
  ## enrollment.
  ## 
  let valid = call_589141.validator(path, query, header, formData, body)
  let scheme = call_589141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589141.url(scheme.get, call_589141.host, call_589141.base,
                         call_589141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589141, url, valid)

proc call*(call_589142: Call_AndroiddeviceprovisioningPartnersDevicesUnclaim_589125;
          partnerId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningPartnersDevicesUnclaim
  ## Unclaims a device from a customer and removes it from zero-touch
  ## enrollment.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   partnerId: string (required)
  ##            : Required. The ID of the reseller partner.
  var path_589143 = newJObject()
  var query_589144 = newJObject()
  var body_589145 = newJObject()
  add(query_589144, "upload_protocol", newJString(uploadProtocol))
  add(query_589144, "fields", newJString(fields))
  add(query_589144, "quotaUser", newJString(quotaUser))
  add(query_589144, "alt", newJString(alt))
  add(query_589144, "oauth_token", newJString(oauthToken))
  add(query_589144, "callback", newJString(callback))
  add(query_589144, "access_token", newJString(accessToken))
  add(query_589144, "uploadType", newJString(uploadType))
  add(query_589144, "key", newJString(key))
  add(query_589144, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589145 = body
  add(query_589144, "prettyPrint", newJBool(prettyPrint))
  add(path_589143, "partnerId", newJString(partnerId))
  result = call_589142.call(path_589143, query_589144, nil, nil, body_589145)

var androiddeviceprovisioningPartnersDevicesUnclaim* = Call_AndroiddeviceprovisioningPartnersDevicesUnclaim_589125(
    name: "androiddeviceprovisioningPartnersDevicesUnclaim",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:unclaim",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesUnclaim_589126,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesUnclaim_589127,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_589146 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_589148(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "partnerId" in path, "`partnerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/partners/"),
               (kind: VariableSegment, value: "partnerId"),
               (kind: ConstantSegment, value: "/devices:unclaimAsync")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_589147(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Unclaims a batch of devices for a customer asynchronously. Removes the
  ## devices from zero-touch enrollment. To learn more, read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partnerId: JString (required)
  ##            : Required. The reseller partner ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partnerId` field"
  var valid_589149 = path.getOrDefault("partnerId")
  valid_589149 = validateParameter(valid_589149, JString, required = true,
                                 default = nil)
  if valid_589149 != nil:
    section.add "partnerId", valid_589149
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589150 = query.getOrDefault("upload_protocol")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "upload_protocol", valid_589150
  var valid_589151 = query.getOrDefault("fields")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "fields", valid_589151
  var valid_589152 = query.getOrDefault("quotaUser")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "quotaUser", valid_589152
  var valid_589153 = query.getOrDefault("alt")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = newJString("json"))
  if valid_589153 != nil:
    section.add "alt", valid_589153
  var valid_589154 = query.getOrDefault("oauth_token")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "oauth_token", valid_589154
  var valid_589155 = query.getOrDefault("callback")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "callback", valid_589155
  var valid_589156 = query.getOrDefault("access_token")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "access_token", valid_589156
  var valid_589157 = query.getOrDefault("uploadType")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "uploadType", valid_589157
  var valid_589158 = query.getOrDefault("key")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "key", valid_589158
  var valid_589159 = query.getOrDefault("$.xgafv")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = newJString("1"))
  if valid_589159 != nil:
    section.add "$.xgafv", valid_589159
  var valid_589160 = query.getOrDefault("prettyPrint")
  valid_589160 = validateParameter(valid_589160, JBool, required = false,
                                 default = newJBool(true))
  if valid_589160 != nil:
    section.add "prettyPrint", valid_589160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589162: Call_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_589146;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unclaims a batch of devices for a customer asynchronously. Removes the
  ## devices from zero-touch enrollment. To learn more, read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ## 
  let valid = call_589162.validator(path, query, header, formData, body)
  let scheme = call_589162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589162.url(scheme.get, call_589162.host, call_589162.base,
                         call_589162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589162, url, valid)

proc call*(call_589163: Call_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_589146;
          partnerId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningPartnersDevicesUnclaimAsync
  ## Unclaims a batch of devices for a customer asynchronously. Removes the
  ## devices from zero-touch enrollment. To learn more, read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   partnerId: string (required)
  ##            : Required. The reseller partner ID.
  var path_589164 = newJObject()
  var query_589165 = newJObject()
  var body_589166 = newJObject()
  add(query_589165, "upload_protocol", newJString(uploadProtocol))
  add(query_589165, "fields", newJString(fields))
  add(query_589165, "quotaUser", newJString(quotaUser))
  add(query_589165, "alt", newJString(alt))
  add(query_589165, "oauth_token", newJString(oauthToken))
  add(query_589165, "callback", newJString(callback))
  add(query_589165, "access_token", newJString(accessToken))
  add(query_589165, "uploadType", newJString(uploadType))
  add(query_589165, "key", newJString(key))
  add(query_589165, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589166 = body
  add(query_589165, "prettyPrint", newJBool(prettyPrint))
  add(path_589164, "partnerId", newJString(partnerId))
  result = call_589163.call(path_589164, query_589165, nil, nil, body_589166)

var androiddeviceprovisioningPartnersDevicesUnclaimAsync* = Call_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_589146(
    name: "androiddeviceprovisioningPartnersDevicesUnclaimAsync",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:unclaimAsync",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_589147,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_589148,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_589167 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_589169(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "partnerId" in path, "`partnerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/partners/"),
               (kind: VariableSegment, value: "partnerId"),
               (kind: ConstantSegment, value: "/devices:updateMetadataAsync")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_589168(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the reseller metadata attached to a batch of devices. This method
  ## updates devices asynchronously and returns an `Operation` that can be used
  ## to track progress. Read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partnerId: JString (required)
  ##            : Required. The reseller partner ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `partnerId` field"
  var valid_589170 = path.getOrDefault("partnerId")
  valid_589170 = validateParameter(valid_589170, JString, required = true,
                                 default = nil)
  if valid_589170 != nil:
    section.add "partnerId", valid_589170
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589171 = query.getOrDefault("upload_protocol")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "upload_protocol", valid_589171
  var valid_589172 = query.getOrDefault("fields")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "fields", valid_589172
  var valid_589173 = query.getOrDefault("quotaUser")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "quotaUser", valid_589173
  var valid_589174 = query.getOrDefault("alt")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = newJString("json"))
  if valid_589174 != nil:
    section.add "alt", valid_589174
  var valid_589175 = query.getOrDefault("oauth_token")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "oauth_token", valid_589175
  var valid_589176 = query.getOrDefault("callback")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "callback", valid_589176
  var valid_589177 = query.getOrDefault("access_token")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "access_token", valid_589177
  var valid_589178 = query.getOrDefault("uploadType")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "uploadType", valid_589178
  var valid_589179 = query.getOrDefault("key")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "key", valid_589179
  var valid_589180 = query.getOrDefault("$.xgafv")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = newJString("1"))
  if valid_589180 != nil:
    section.add "$.xgafv", valid_589180
  var valid_589181 = query.getOrDefault("prettyPrint")
  valid_589181 = validateParameter(valid_589181, JBool, required = false,
                                 default = newJBool(true))
  if valid_589181 != nil:
    section.add "prettyPrint", valid_589181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589183: Call_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_589167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the reseller metadata attached to a batch of devices. This method
  ## updates devices asynchronously and returns an `Operation` that can be used
  ## to track progress. Read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ## 
  let valid = call_589183.validator(path, query, header, formData, body)
  let scheme = call_589183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589183.url(scheme.get, call_589183.host, call_589183.base,
                         call_589183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589183, url, valid)

proc call*(call_589184: Call_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_589167;
          partnerId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningPartnersDevicesUpdateMetadataAsync
  ## Updates the reseller metadata attached to a batch of devices. This method
  ## updates devices asynchronously and returns an `Operation` that can be used
  ## to track progress. Read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   partnerId: string (required)
  ##            : Required. The reseller partner ID.
  var path_589185 = newJObject()
  var query_589186 = newJObject()
  var body_589187 = newJObject()
  add(query_589186, "upload_protocol", newJString(uploadProtocol))
  add(query_589186, "fields", newJString(fields))
  add(query_589186, "quotaUser", newJString(quotaUser))
  add(query_589186, "alt", newJString(alt))
  add(query_589186, "oauth_token", newJString(oauthToken))
  add(query_589186, "callback", newJString(callback))
  add(query_589186, "access_token", newJString(accessToken))
  add(query_589186, "uploadType", newJString(uploadType))
  add(query_589186, "key", newJString(key))
  add(query_589186, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589187 = body
  add(query_589186, "prettyPrint", newJBool(prettyPrint))
  add(path_589185, "partnerId", newJString(partnerId))
  result = call_589184.call(path_589185, query_589186, nil, nil, body_589187)

var androiddeviceprovisioningPartnersDevicesUpdateMetadataAsync* = Call_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_589167(
    name: "androiddeviceprovisioningPartnersDevicesUpdateMetadataAsync",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:updateMetadataAsync", validator: validate_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_589168,
    base: "/",
    url: url_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_589169,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesGet_589188 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningCustomersDevicesGet_589190(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersDevicesGet_589189(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The device to get. An API resource name in the format
  ## `customers/[CUSTOMER_ID]/devices/[DEVICE_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589191 = path.getOrDefault("name")
  valid_589191 = validateParameter(valid_589191, JString, required = true,
                                 default = nil)
  if valid_589191 != nil:
    section.add "name", valid_589191
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589192 = query.getOrDefault("upload_protocol")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "upload_protocol", valid_589192
  var valid_589193 = query.getOrDefault("fields")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "fields", valid_589193
  var valid_589194 = query.getOrDefault("quotaUser")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "quotaUser", valid_589194
  var valid_589195 = query.getOrDefault("alt")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = newJString("json"))
  if valid_589195 != nil:
    section.add "alt", valid_589195
  var valid_589196 = query.getOrDefault("oauth_token")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "oauth_token", valid_589196
  var valid_589197 = query.getOrDefault("callback")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "callback", valid_589197
  var valid_589198 = query.getOrDefault("access_token")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "access_token", valid_589198
  var valid_589199 = query.getOrDefault("uploadType")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "uploadType", valid_589199
  var valid_589200 = query.getOrDefault("key")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "key", valid_589200
  var valid_589201 = query.getOrDefault("$.xgafv")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = newJString("1"))
  if valid_589201 != nil:
    section.add "$.xgafv", valid_589201
  var valid_589202 = query.getOrDefault("prettyPrint")
  valid_589202 = validateParameter(valid_589202, JBool, required = false,
                                 default = newJBool(true))
  if valid_589202 != nil:
    section.add "prettyPrint", valid_589202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589203: Call_AndroiddeviceprovisioningCustomersDevicesGet_589188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a device.
  ## 
  let valid = call_589203.validator(path, query, header, formData, body)
  let scheme = call_589203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589203.url(scheme.get, call_589203.host, call_589203.base,
                         call_589203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589203, url, valid)

proc call*(call_589204: Call_AndroiddeviceprovisioningCustomersDevicesGet_589188;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningCustomersDevicesGet
  ## Gets the details of a device.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The device to get. An API resource name in the format
  ## `customers/[CUSTOMER_ID]/devices/[DEVICE_ID]`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589205 = newJObject()
  var query_589206 = newJObject()
  add(query_589206, "upload_protocol", newJString(uploadProtocol))
  add(query_589206, "fields", newJString(fields))
  add(query_589206, "quotaUser", newJString(quotaUser))
  add(path_589205, "name", newJString(name))
  add(query_589206, "alt", newJString(alt))
  add(query_589206, "oauth_token", newJString(oauthToken))
  add(query_589206, "callback", newJString(callback))
  add(query_589206, "access_token", newJString(accessToken))
  add(query_589206, "uploadType", newJString(uploadType))
  add(query_589206, "key", newJString(key))
  add(query_589206, "$.xgafv", newJString(Xgafv))
  add(query_589206, "prettyPrint", newJBool(prettyPrint))
  result = call_589204.call(path_589205, query_589206, nil, nil, nil)

var androiddeviceprovisioningCustomersDevicesGet* = Call_AndroiddeviceprovisioningCustomersDevicesGet_589188(
    name: "androiddeviceprovisioningCustomersDevicesGet",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AndroiddeviceprovisioningCustomersDevicesGet_589189,
    base: "/", url: url_AndroiddeviceprovisioningCustomersDevicesGet_589190,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersConfigurationsPatch_589226 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningCustomersConfigurationsPatch_589228(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersConfigurationsPatch_589227(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates a configuration's field values.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Output only. The API resource name in the format
  ## `customers/[CUSTOMER_ID]/configurations/[CONFIGURATION_ID]`. Assigned by
  ## the server.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589229 = path.getOrDefault("name")
  valid_589229 = validateParameter(valid_589229, JString, required = true,
                                 default = nil)
  if valid_589229 != nil:
    section.add "name", valid_589229
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Required. The field mask applied to the target `Configuration` before
  ## updating the fields. To learn more about using field masks, read
  ## [FieldMask](/protocol-buffers/docs/reference/google.protobuf#fieldmask) in
  ## the Protocol Buffers documentation.
  section = newJObject()
  var valid_589230 = query.getOrDefault("upload_protocol")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "upload_protocol", valid_589230
  var valid_589231 = query.getOrDefault("fields")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "fields", valid_589231
  var valid_589232 = query.getOrDefault("quotaUser")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "quotaUser", valid_589232
  var valid_589233 = query.getOrDefault("alt")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = newJString("json"))
  if valid_589233 != nil:
    section.add "alt", valid_589233
  var valid_589234 = query.getOrDefault("oauth_token")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "oauth_token", valid_589234
  var valid_589235 = query.getOrDefault("callback")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "callback", valid_589235
  var valid_589236 = query.getOrDefault("access_token")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "access_token", valid_589236
  var valid_589237 = query.getOrDefault("uploadType")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "uploadType", valid_589237
  var valid_589238 = query.getOrDefault("key")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "key", valid_589238
  var valid_589239 = query.getOrDefault("$.xgafv")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = newJString("1"))
  if valid_589239 != nil:
    section.add "$.xgafv", valid_589239
  var valid_589240 = query.getOrDefault("prettyPrint")
  valid_589240 = validateParameter(valid_589240, JBool, required = false,
                                 default = newJBool(true))
  if valid_589240 != nil:
    section.add "prettyPrint", valid_589240
  var valid_589241 = query.getOrDefault("updateMask")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "updateMask", valid_589241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589243: Call_AndroiddeviceprovisioningCustomersConfigurationsPatch_589226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a configuration's field values.
  ## 
  let valid = call_589243.validator(path, query, header, formData, body)
  let scheme = call_589243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589243.url(scheme.get, call_589243.host, call_589243.base,
                         call_589243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589243, url, valid)

proc call*(call_589244: Call_AndroiddeviceprovisioningCustomersConfigurationsPatch_589226;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## androiddeviceprovisioningCustomersConfigurationsPatch
  ## Updates a configuration's field values.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Output only. The API resource name in the format
  ## `customers/[CUSTOMER_ID]/configurations/[CONFIGURATION_ID]`. Assigned by
  ## the server.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Required. The field mask applied to the target `Configuration` before
  ## updating the fields. To learn more about using field masks, read
  ## [FieldMask](/protocol-buffers/docs/reference/google.protobuf#fieldmask) in
  ## the Protocol Buffers documentation.
  var path_589245 = newJObject()
  var query_589246 = newJObject()
  var body_589247 = newJObject()
  add(query_589246, "upload_protocol", newJString(uploadProtocol))
  add(query_589246, "fields", newJString(fields))
  add(query_589246, "quotaUser", newJString(quotaUser))
  add(path_589245, "name", newJString(name))
  add(query_589246, "alt", newJString(alt))
  add(query_589246, "oauth_token", newJString(oauthToken))
  add(query_589246, "callback", newJString(callback))
  add(query_589246, "access_token", newJString(accessToken))
  add(query_589246, "uploadType", newJString(uploadType))
  add(query_589246, "key", newJString(key))
  add(query_589246, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589247 = body
  add(query_589246, "prettyPrint", newJBool(prettyPrint))
  add(query_589246, "updateMask", newJString(updateMask))
  result = call_589244.call(path_589245, query_589246, nil, nil, body_589247)

var androiddeviceprovisioningCustomersConfigurationsPatch* = Call_AndroiddeviceprovisioningCustomersConfigurationsPatch_589226(
    name: "androiddeviceprovisioningCustomersConfigurationsPatch",
    meth: HttpMethod.HttpPatch, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AndroiddeviceprovisioningCustomersConfigurationsPatch_589227,
    base: "/", url: url_AndroiddeviceprovisioningCustomersConfigurationsPatch_589228,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersConfigurationsDelete_589207 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningCustomersConfigurationsDelete_589209(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersConfigurationsDelete_589208(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes an unused configuration. The API call fails if the customer has
  ## devices with the configuration applied.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The configuration to delete. An API resource name in the format
  ## `customers/[CUSTOMER_ID]/configurations/[CONFIGURATION_ID]`. If the
  ## configuration is applied to any devices, the API call fails.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589210 = path.getOrDefault("name")
  valid_589210 = validateParameter(valid_589210, JString, required = true,
                                 default = nil)
  if valid_589210 != nil:
    section.add "name", valid_589210
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589211 = query.getOrDefault("upload_protocol")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "upload_protocol", valid_589211
  var valid_589212 = query.getOrDefault("fields")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "fields", valid_589212
  var valid_589213 = query.getOrDefault("quotaUser")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "quotaUser", valid_589213
  var valid_589214 = query.getOrDefault("alt")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = newJString("json"))
  if valid_589214 != nil:
    section.add "alt", valid_589214
  var valid_589215 = query.getOrDefault("oauth_token")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "oauth_token", valid_589215
  var valid_589216 = query.getOrDefault("callback")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "callback", valid_589216
  var valid_589217 = query.getOrDefault("access_token")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "access_token", valid_589217
  var valid_589218 = query.getOrDefault("uploadType")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "uploadType", valid_589218
  var valid_589219 = query.getOrDefault("key")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "key", valid_589219
  var valid_589220 = query.getOrDefault("$.xgafv")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = newJString("1"))
  if valid_589220 != nil:
    section.add "$.xgafv", valid_589220
  var valid_589221 = query.getOrDefault("prettyPrint")
  valid_589221 = validateParameter(valid_589221, JBool, required = false,
                                 default = newJBool(true))
  if valid_589221 != nil:
    section.add "prettyPrint", valid_589221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589222: Call_AndroiddeviceprovisioningCustomersConfigurationsDelete_589207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an unused configuration. The API call fails if the customer has
  ## devices with the configuration applied.
  ## 
  let valid = call_589222.validator(path, query, header, formData, body)
  let scheme = call_589222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589222.url(scheme.get, call_589222.host, call_589222.base,
                         call_589222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589222, url, valid)

proc call*(call_589223: Call_AndroiddeviceprovisioningCustomersConfigurationsDelete_589207;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningCustomersConfigurationsDelete
  ## Deletes an unused configuration. The API call fails if the customer has
  ## devices with the configuration applied.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The configuration to delete. An API resource name in the format
  ## `customers/[CUSTOMER_ID]/configurations/[CONFIGURATION_ID]`. If the
  ## configuration is applied to any devices, the API call fails.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589224 = newJObject()
  var query_589225 = newJObject()
  add(query_589225, "upload_protocol", newJString(uploadProtocol))
  add(query_589225, "fields", newJString(fields))
  add(query_589225, "quotaUser", newJString(quotaUser))
  add(path_589224, "name", newJString(name))
  add(query_589225, "alt", newJString(alt))
  add(query_589225, "oauth_token", newJString(oauthToken))
  add(query_589225, "callback", newJString(callback))
  add(query_589225, "access_token", newJString(accessToken))
  add(query_589225, "uploadType", newJString(uploadType))
  add(query_589225, "key", newJString(key))
  add(query_589225, "$.xgafv", newJString(Xgafv))
  add(query_589225, "prettyPrint", newJBool(prettyPrint))
  result = call_589223.call(path_589224, query_589225, nil, nil, nil)

var androiddeviceprovisioningCustomersConfigurationsDelete* = Call_AndroiddeviceprovisioningCustomersConfigurationsDelete_589207(
    name: "androiddeviceprovisioningCustomersConfigurationsDelete",
    meth: HttpMethod.HttpDelete, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AndroiddeviceprovisioningCustomersConfigurationsDelete_589208,
    base: "/", url: url_AndroiddeviceprovisioningCustomersConfigurationsDelete_589209,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersConfigurationsCreate_589267 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningCustomersConfigurationsCreate_589269(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersConfigurationsCreate_589268(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new configuration. Once created, a customer can apply the
  ## configuration to devices.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The customer that manages the configuration. An API resource name
  ## in the format `customers/[CUSTOMER_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589270 = path.getOrDefault("parent")
  valid_589270 = validateParameter(valid_589270, JString, required = true,
                                 default = nil)
  if valid_589270 != nil:
    section.add "parent", valid_589270
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589271 = query.getOrDefault("upload_protocol")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "upload_protocol", valid_589271
  var valid_589272 = query.getOrDefault("fields")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "fields", valid_589272
  var valid_589273 = query.getOrDefault("quotaUser")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "quotaUser", valid_589273
  var valid_589274 = query.getOrDefault("alt")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = newJString("json"))
  if valid_589274 != nil:
    section.add "alt", valid_589274
  var valid_589275 = query.getOrDefault("oauth_token")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "oauth_token", valid_589275
  var valid_589276 = query.getOrDefault("callback")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "callback", valid_589276
  var valid_589277 = query.getOrDefault("access_token")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "access_token", valid_589277
  var valid_589278 = query.getOrDefault("uploadType")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "uploadType", valid_589278
  var valid_589279 = query.getOrDefault("key")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "key", valid_589279
  var valid_589280 = query.getOrDefault("$.xgafv")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = newJString("1"))
  if valid_589280 != nil:
    section.add "$.xgafv", valid_589280
  var valid_589281 = query.getOrDefault("prettyPrint")
  valid_589281 = validateParameter(valid_589281, JBool, required = false,
                                 default = newJBool(true))
  if valid_589281 != nil:
    section.add "prettyPrint", valid_589281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589283: Call_AndroiddeviceprovisioningCustomersConfigurationsCreate_589267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new configuration. Once created, a customer can apply the
  ## configuration to devices.
  ## 
  let valid = call_589283.validator(path, query, header, formData, body)
  let scheme = call_589283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589283.url(scheme.get, call_589283.host, call_589283.base,
                         call_589283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589283, url, valid)

proc call*(call_589284: Call_AndroiddeviceprovisioningCustomersConfigurationsCreate_589267;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningCustomersConfigurationsCreate
  ## Creates a new configuration. Once created, a customer can apply the
  ## configuration to devices.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The customer that manages the configuration. An API resource name
  ## in the format `customers/[CUSTOMER_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589285 = newJObject()
  var query_589286 = newJObject()
  var body_589287 = newJObject()
  add(query_589286, "upload_protocol", newJString(uploadProtocol))
  add(query_589286, "fields", newJString(fields))
  add(query_589286, "quotaUser", newJString(quotaUser))
  add(query_589286, "alt", newJString(alt))
  add(query_589286, "oauth_token", newJString(oauthToken))
  add(query_589286, "callback", newJString(callback))
  add(query_589286, "access_token", newJString(accessToken))
  add(query_589286, "uploadType", newJString(uploadType))
  add(path_589285, "parent", newJString(parent))
  add(query_589286, "key", newJString(key))
  add(query_589286, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589287 = body
  add(query_589286, "prettyPrint", newJBool(prettyPrint))
  result = call_589284.call(path_589285, query_589286, nil, nil, body_589287)

var androiddeviceprovisioningCustomersConfigurationsCreate* = Call_AndroiddeviceprovisioningCustomersConfigurationsCreate_589267(
    name: "androiddeviceprovisioningCustomersConfigurationsCreate",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/configurations",
    validator: validate_AndroiddeviceprovisioningCustomersConfigurationsCreate_589268,
    base: "/", url: url_AndroiddeviceprovisioningCustomersConfigurationsCreate_589269,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersConfigurationsList_589248 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningCustomersConfigurationsList_589250(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersConfigurationsList_589249(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists a customer's configurations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The customer that manages the listed configurations. An API
  ## resource name in the format `customers/[CUSTOMER_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589251 = path.getOrDefault("parent")
  valid_589251 = validateParameter(valid_589251, JString, required = true,
                                 default = nil)
  if valid_589251 != nil:
    section.add "parent", valid_589251
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589252 = query.getOrDefault("upload_protocol")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "upload_protocol", valid_589252
  var valid_589253 = query.getOrDefault("fields")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "fields", valid_589253
  var valid_589254 = query.getOrDefault("quotaUser")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "quotaUser", valid_589254
  var valid_589255 = query.getOrDefault("alt")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = newJString("json"))
  if valid_589255 != nil:
    section.add "alt", valid_589255
  var valid_589256 = query.getOrDefault("oauth_token")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "oauth_token", valid_589256
  var valid_589257 = query.getOrDefault("callback")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "callback", valid_589257
  var valid_589258 = query.getOrDefault("access_token")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "access_token", valid_589258
  var valid_589259 = query.getOrDefault("uploadType")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "uploadType", valid_589259
  var valid_589260 = query.getOrDefault("key")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "key", valid_589260
  var valid_589261 = query.getOrDefault("$.xgafv")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = newJString("1"))
  if valid_589261 != nil:
    section.add "$.xgafv", valid_589261
  var valid_589262 = query.getOrDefault("prettyPrint")
  valid_589262 = validateParameter(valid_589262, JBool, required = false,
                                 default = newJBool(true))
  if valid_589262 != nil:
    section.add "prettyPrint", valid_589262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589263: Call_AndroiddeviceprovisioningCustomersConfigurationsList_589248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a customer's configurations.
  ## 
  let valid = call_589263.validator(path, query, header, formData, body)
  let scheme = call_589263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589263.url(scheme.get, call_589263.host, call_589263.base,
                         call_589263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589263, url, valid)

proc call*(call_589264: Call_AndroiddeviceprovisioningCustomersConfigurationsList_589248;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningCustomersConfigurationsList
  ## Lists a customer's configurations.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The customer that manages the listed configurations. An API
  ## resource name in the format `customers/[CUSTOMER_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589265 = newJObject()
  var query_589266 = newJObject()
  add(query_589266, "upload_protocol", newJString(uploadProtocol))
  add(query_589266, "fields", newJString(fields))
  add(query_589266, "quotaUser", newJString(quotaUser))
  add(query_589266, "alt", newJString(alt))
  add(query_589266, "oauth_token", newJString(oauthToken))
  add(query_589266, "callback", newJString(callback))
  add(query_589266, "access_token", newJString(accessToken))
  add(query_589266, "uploadType", newJString(uploadType))
  add(path_589265, "parent", newJString(parent))
  add(query_589266, "key", newJString(key))
  add(query_589266, "$.xgafv", newJString(Xgafv))
  add(query_589266, "prettyPrint", newJBool(prettyPrint))
  result = call_589264.call(path_589265, query_589266, nil, nil, nil)

var androiddeviceprovisioningCustomersConfigurationsList* = Call_AndroiddeviceprovisioningCustomersConfigurationsList_589248(
    name: "androiddeviceprovisioningCustomersConfigurationsList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/configurations",
    validator: validate_AndroiddeviceprovisioningCustomersConfigurationsList_589249,
    base: "/", url: url_AndroiddeviceprovisioningCustomersConfigurationsList_589250,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersCustomersCreate_589309 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningPartnersCustomersCreate_589311(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/customers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersCustomersCreate_589310(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a customer for zero-touch enrollment. After the method returns
  ## successfully, admin and owner roles can manage devices and EMM configs
  ## by calling API methods or using their zero-touch enrollment portal.
  ## The customer receives an email that welcomes them to zero-touch enrollment
  ## and explains how to sign into the portal.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The parent resource ID in the format `partners/[PARTNER_ID]` that
  ## identifies the reseller.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589312 = path.getOrDefault("parent")
  valid_589312 = validateParameter(valid_589312, JString, required = true,
                                 default = nil)
  if valid_589312 != nil:
    section.add "parent", valid_589312
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589313 = query.getOrDefault("upload_protocol")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "upload_protocol", valid_589313
  var valid_589314 = query.getOrDefault("fields")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "fields", valid_589314
  var valid_589315 = query.getOrDefault("quotaUser")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "quotaUser", valid_589315
  var valid_589316 = query.getOrDefault("alt")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = newJString("json"))
  if valid_589316 != nil:
    section.add "alt", valid_589316
  var valid_589317 = query.getOrDefault("oauth_token")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "oauth_token", valid_589317
  var valid_589318 = query.getOrDefault("callback")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "callback", valid_589318
  var valid_589319 = query.getOrDefault("access_token")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "access_token", valid_589319
  var valid_589320 = query.getOrDefault("uploadType")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "uploadType", valid_589320
  var valid_589321 = query.getOrDefault("key")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "key", valid_589321
  var valid_589322 = query.getOrDefault("$.xgafv")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = newJString("1"))
  if valid_589322 != nil:
    section.add "$.xgafv", valid_589322
  var valid_589323 = query.getOrDefault("prettyPrint")
  valid_589323 = validateParameter(valid_589323, JBool, required = false,
                                 default = newJBool(true))
  if valid_589323 != nil:
    section.add "prettyPrint", valid_589323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589325: Call_AndroiddeviceprovisioningPartnersCustomersCreate_589309;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a customer for zero-touch enrollment. After the method returns
  ## successfully, admin and owner roles can manage devices and EMM configs
  ## by calling API methods or using their zero-touch enrollment portal.
  ## The customer receives an email that welcomes them to zero-touch enrollment
  ## and explains how to sign into the portal.
  ## 
  let valid = call_589325.validator(path, query, header, formData, body)
  let scheme = call_589325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589325.url(scheme.get, call_589325.host, call_589325.base,
                         call_589325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589325, url, valid)

proc call*(call_589326: Call_AndroiddeviceprovisioningPartnersCustomersCreate_589309;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningPartnersCustomersCreate
  ## Creates a customer for zero-touch enrollment. After the method returns
  ## successfully, admin and owner roles can manage devices and EMM configs
  ## by calling API methods or using their zero-touch enrollment portal.
  ## The customer receives an email that welcomes them to zero-touch enrollment
  ## and explains how to sign into the portal.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The parent resource ID in the format `partners/[PARTNER_ID]` that
  ## identifies the reseller.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589327 = newJObject()
  var query_589328 = newJObject()
  var body_589329 = newJObject()
  add(query_589328, "upload_protocol", newJString(uploadProtocol))
  add(query_589328, "fields", newJString(fields))
  add(query_589328, "quotaUser", newJString(quotaUser))
  add(query_589328, "alt", newJString(alt))
  add(query_589328, "oauth_token", newJString(oauthToken))
  add(query_589328, "callback", newJString(callback))
  add(query_589328, "access_token", newJString(accessToken))
  add(query_589328, "uploadType", newJString(uploadType))
  add(path_589327, "parent", newJString(parent))
  add(query_589328, "key", newJString(key))
  add(query_589328, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589329 = body
  add(query_589328, "prettyPrint", newJBool(prettyPrint))
  result = call_589326.call(path_589327, query_589328, nil, nil, body_589329)

var androiddeviceprovisioningPartnersCustomersCreate* = Call_AndroiddeviceprovisioningPartnersCustomersCreate_589309(
    name: "androiddeviceprovisioningPartnersCustomersCreate",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/customers",
    validator: validate_AndroiddeviceprovisioningPartnersCustomersCreate_589310,
    base: "/", url: url_AndroiddeviceprovisioningPartnersCustomersCreate_589311,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersVendorsCustomersList_589288 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningPartnersVendorsCustomersList_589290(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/customers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersVendorsCustomersList_589289(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the customers of the vendor.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name in the format
  ## `partners/[PARTNER_ID]/vendors/[VENDOR_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589291 = path.getOrDefault("parent")
  valid_589291 = validateParameter(valid_589291, JString, required = true,
                                 default = nil)
  if valid_589291 != nil:
    section.add "parent", valid_589291
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results returned by the server.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of results to be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589292 = query.getOrDefault("upload_protocol")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "upload_protocol", valid_589292
  var valid_589293 = query.getOrDefault("fields")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "fields", valid_589293
  var valid_589294 = query.getOrDefault("pageToken")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "pageToken", valid_589294
  var valid_589295 = query.getOrDefault("quotaUser")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "quotaUser", valid_589295
  var valid_589296 = query.getOrDefault("alt")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = newJString("json"))
  if valid_589296 != nil:
    section.add "alt", valid_589296
  var valid_589297 = query.getOrDefault("oauth_token")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "oauth_token", valid_589297
  var valid_589298 = query.getOrDefault("callback")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "callback", valid_589298
  var valid_589299 = query.getOrDefault("access_token")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "access_token", valid_589299
  var valid_589300 = query.getOrDefault("uploadType")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "uploadType", valid_589300
  var valid_589301 = query.getOrDefault("key")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "key", valid_589301
  var valid_589302 = query.getOrDefault("$.xgafv")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = newJString("1"))
  if valid_589302 != nil:
    section.add "$.xgafv", valid_589302
  var valid_589303 = query.getOrDefault("pageSize")
  valid_589303 = validateParameter(valid_589303, JInt, required = false, default = nil)
  if valid_589303 != nil:
    section.add "pageSize", valid_589303
  var valid_589304 = query.getOrDefault("prettyPrint")
  valid_589304 = validateParameter(valid_589304, JBool, required = false,
                                 default = newJBool(true))
  if valid_589304 != nil:
    section.add "prettyPrint", valid_589304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589305: Call_AndroiddeviceprovisioningPartnersVendorsCustomersList_589288;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the customers of the vendor.
  ## 
  let valid = call_589305.validator(path, query, header, formData, body)
  let scheme = call_589305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589305.url(scheme.get, call_589305.host, call_589305.base,
                         call_589305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589305, url, valid)

proc call*(call_589306: Call_AndroiddeviceprovisioningPartnersVendorsCustomersList_589288;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningPartnersVendorsCustomersList
  ## Lists the customers of the vendor.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results returned by the server.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The resource name in the format
  ## `partners/[PARTNER_ID]/vendors/[VENDOR_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589307 = newJObject()
  var query_589308 = newJObject()
  add(query_589308, "upload_protocol", newJString(uploadProtocol))
  add(query_589308, "fields", newJString(fields))
  add(query_589308, "pageToken", newJString(pageToken))
  add(query_589308, "quotaUser", newJString(quotaUser))
  add(query_589308, "alt", newJString(alt))
  add(query_589308, "oauth_token", newJString(oauthToken))
  add(query_589308, "callback", newJString(callback))
  add(query_589308, "access_token", newJString(accessToken))
  add(query_589308, "uploadType", newJString(uploadType))
  add(path_589307, "parent", newJString(parent))
  add(query_589308, "key", newJString(key))
  add(query_589308, "$.xgafv", newJString(Xgafv))
  add(query_589308, "pageSize", newJInt(pageSize))
  add(query_589308, "prettyPrint", newJBool(prettyPrint))
  result = call_589306.call(path_589307, query_589308, nil, nil, nil)

var androiddeviceprovisioningPartnersVendorsCustomersList* = Call_AndroiddeviceprovisioningPartnersVendorsCustomersList_589288(
    name: "androiddeviceprovisioningPartnersVendorsCustomersList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/customers",
    validator: validate_AndroiddeviceprovisioningPartnersVendorsCustomersList_589289,
    base: "/", url: url_AndroiddeviceprovisioningPartnersVendorsCustomersList_589290,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesList_589330 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningCustomersDevicesList_589332(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/devices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersDevicesList_589331(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists a customer's devices.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The customer managing the devices. An API resource name in the
  ## format `customers/[CUSTOMER_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589333 = path.getOrDefault("parent")
  valid_589333 = validateParameter(valid_589333, JString, required = true,
                                 default = nil)
  if valid_589333 != nil:
    section.add "parent", valid_589333
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token specifying which result page to return.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JString
  ##           : The maximum number of devices to show in a page of results.
  ## Must be between 1 and 100 inclusive.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589334 = query.getOrDefault("upload_protocol")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "upload_protocol", valid_589334
  var valid_589335 = query.getOrDefault("fields")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "fields", valid_589335
  var valid_589336 = query.getOrDefault("pageToken")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "pageToken", valid_589336
  var valid_589337 = query.getOrDefault("quotaUser")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "quotaUser", valid_589337
  var valid_589338 = query.getOrDefault("alt")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = newJString("json"))
  if valid_589338 != nil:
    section.add "alt", valid_589338
  var valid_589339 = query.getOrDefault("oauth_token")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "oauth_token", valid_589339
  var valid_589340 = query.getOrDefault("callback")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "callback", valid_589340
  var valid_589341 = query.getOrDefault("access_token")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "access_token", valid_589341
  var valid_589342 = query.getOrDefault("uploadType")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "uploadType", valid_589342
  var valid_589343 = query.getOrDefault("key")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = nil)
  if valid_589343 != nil:
    section.add "key", valid_589343
  var valid_589344 = query.getOrDefault("$.xgafv")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = newJString("1"))
  if valid_589344 != nil:
    section.add "$.xgafv", valid_589344
  var valid_589345 = query.getOrDefault("pageSize")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "pageSize", valid_589345
  var valid_589346 = query.getOrDefault("prettyPrint")
  valid_589346 = validateParameter(valid_589346, JBool, required = false,
                                 default = newJBool(true))
  if valid_589346 != nil:
    section.add "prettyPrint", valid_589346
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589347: Call_AndroiddeviceprovisioningCustomersDevicesList_589330;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a customer's devices.
  ## 
  let valid = call_589347.validator(path, query, header, formData, body)
  let scheme = call_589347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589347.url(scheme.get, call_589347.host, call_589347.base,
                         call_589347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589347, url, valid)

proc call*(call_589348: Call_AndroiddeviceprovisioningCustomersDevicesList_589330;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          pageSize: string = ""; prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningCustomersDevicesList
  ## Lists a customer's devices.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token specifying which result page to return.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The customer managing the devices. An API resource name in the
  ## format `customers/[CUSTOMER_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: string
  ##           : The maximum number of devices to show in a page of results.
  ## Must be between 1 and 100 inclusive.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589349 = newJObject()
  var query_589350 = newJObject()
  add(query_589350, "upload_protocol", newJString(uploadProtocol))
  add(query_589350, "fields", newJString(fields))
  add(query_589350, "pageToken", newJString(pageToken))
  add(query_589350, "quotaUser", newJString(quotaUser))
  add(query_589350, "alt", newJString(alt))
  add(query_589350, "oauth_token", newJString(oauthToken))
  add(query_589350, "callback", newJString(callback))
  add(query_589350, "access_token", newJString(accessToken))
  add(query_589350, "uploadType", newJString(uploadType))
  add(path_589349, "parent", newJString(parent))
  add(query_589350, "key", newJString(key))
  add(query_589350, "$.xgafv", newJString(Xgafv))
  add(query_589350, "pageSize", newJString(pageSize))
  add(query_589350, "prettyPrint", newJBool(prettyPrint))
  result = call_589348.call(path_589349, query_589350, nil, nil, nil)

var androiddeviceprovisioningCustomersDevicesList* = Call_AndroiddeviceprovisioningCustomersDevicesList_589330(
    name: "androiddeviceprovisioningCustomersDevicesList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/devices",
    validator: validate_AndroiddeviceprovisioningCustomersDevicesList_589331,
    base: "/", url: url_AndroiddeviceprovisioningCustomersDevicesList_589332,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_589351 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_589353(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/devices:applyConfiguration")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_589352(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Applies a Configuration to the device to register the device for zero-touch
  ## enrollment. After applying a configuration to a device, the device
  ## automatically provisions itself on first boot, or next factory reset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The customer managing the device. An API resource name in the
  ## format `customers/[CUSTOMER_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589354 = path.getOrDefault("parent")
  valid_589354 = validateParameter(valid_589354, JString, required = true,
                                 default = nil)
  if valid_589354 != nil:
    section.add "parent", valid_589354
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589355 = query.getOrDefault("upload_protocol")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = nil)
  if valid_589355 != nil:
    section.add "upload_protocol", valid_589355
  var valid_589356 = query.getOrDefault("fields")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "fields", valid_589356
  var valid_589357 = query.getOrDefault("quotaUser")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "quotaUser", valid_589357
  var valid_589358 = query.getOrDefault("alt")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = newJString("json"))
  if valid_589358 != nil:
    section.add "alt", valid_589358
  var valid_589359 = query.getOrDefault("oauth_token")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "oauth_token", valid_589359
  var valid_589360 = query.getOrDefault("callback")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "callback", valid_589360
  var valid_589361 = query.getOrDefault("access_token")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "access_token", valid_589361
  var valid_589362 = query.getOrDefault("uploadType")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "uploadType", valid_589362
  var valid_589363 = query.getOrDefault("key")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "key", valid_589363
  var valid_589364 = query.getOrDefault("$.xgafv")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = newJString("1"))
  if valid_589364 != nil:
    section.add "$.xgafv", valid_589364
  var valid_589365 = query.getOrDefault("prettyPrint")
  valid_589365 = validateParameter(valid_589365, JBool, required = false,
                                 default = newJBool(true))
  if valid_589365 != nil:
    section.add "prettyPrint", valid_589365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589367: Call_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_589351;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Applies a Configuration to the device to register the device for zero-touch
  ## enrollment. After applying a configuration to a device, the device
  ## automatically provisions itself on first boot, or next factory reset.
  ## 
  let valid = call_589367.validator(path, query, header, formData, body)
  let scheme = call_589367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589367.url(scheme.get, call_589367.host, call_589367.base,
                         call_589367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589367, url, valid)

proc call*(call_589368: Call_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_589351;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningCustomersDevicesApplyConfiguration
  ## Applies a Configuration to the device to register the device for zero-touch
  ## enrollment. After applying a configuration to a device, the device
  ## automatically provisions itself on first boot, or next factory reset.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The customer managing the device. An API resource name in the
  ## format `customers/[CUSTOMER_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589369 = newJObject()
  var query_589370 = newJObject()
  var body_589371 = newJObject()
  add(query_589370, "upload_protocol", newJString(uploadProtocol))
  add(query_589370, "fields", newJString(fields))
  add(query_589370, "quotaUser", newJString(quotaUser))
  add(query_589370, "alt", newJString(alt))
  add(query_589370, "oauth_token", newJString(oauthToken))
  add(query_589370, "callback", newJString(callback))
  add(query_589370, "access_token", newJString(accessToken))
  add(query_589370, "uploadType", newJString(uploadType))
  add(path_589369, "parent", newJString(parent))
  add(query_589370, "key", newJString(key))
  add(query_589370, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589371 = body
  add(query_589370, "prettyPrint", newJBool(prettyPrint))
  result = call_589368.call(path_589369, query_589370, nil, nil, body_589371)

var androiddeviceprovisioningCustomersDevicesApplyConfiguration* = Call_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_589351(
    name: "androiddeviceprovisioningCustomersDevicesApplyConfiguration",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/devices:applyConfiguration", validator: validate_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_589352,
    base: "/",
    url: url_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_589353,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_589372 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_589374(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/devices:removeConfiguration")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_589373(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Removes a configuration from device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The customer managing the device in the format
  ## `customers/[CUSTOMER_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589375 = path.getOrDefault("parent")
  valid_589375 = validateParameter(valid_589375, JString, required = true,
                                 default = nil)
  if valid_589375 != nil:
    section.add "parent", valid_589375
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589376 = query.getOrDefault("upload_protocol")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "upload_protocol", valid_589376
  var valid_589377 = query.getOrDefault("fields")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "fields", valid_589377
  var valid_589378 = query.getOrDefault("quotaUser")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "quotaUser", valid_589378
  var valid_589379 = query.getOrDefault("alt")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = newJString("json"))
  if valid_589379 != nil:
    section.add "alt", valid_589379
  var valid_589380 = query.getOrDefault("oauth_token")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "oauth_token", valid_589380
  var valid_589381 = query.getOrDefault("callback")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "callback", valid_589381
  var valid_589382 = query.getOrDefault("access_token")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "access_token", valid_589382
  var valid_589383 = query.getOrDefault("uploadType")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "uploadType", valid_589383
  var valid_589384 = query.getOrDefault("key")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "key", valid_589384
  var valid_589385 = query.getOrDefault("$.xgafv")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = newJString("1"))
  if valid_589385 != nil:
    section.add "$.xgafv", valid_589385
  var valid_589386 = query.getOrDefault("prettyPrint")
  valid_589386 = validateParameter(valid_589386, JBool, required = false,
                                 default = newJBool(true))
  if valid_589386 != nil:
    section.add "prettyPrint", valid_589386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589388: Call_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_589372;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a configuration from device.
  ## 
  let valid = call_589388.validator(path, query, header, formData, body)
  let scheme = call_589388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589388.url(scheme.get, call_589388.host, call_589388.base,
                         call_589388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589388, url, valid)

proc call*(call_589389: Call_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_589372;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningCustomersDevicesRemoveConfiguration
  ## Removes a configuration from device.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The customer managing the device in the format
  ## `customers/[CUSTOMER_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589390 = newJObject()
  var query_589391 = newJObject()
  var body_589392 = newJObject()
  add(query_589391, "upload_protocol", newJString(uploadProtocol))
  add(query_589391, "fields", newJString(fields))
  add(query_589391, "quotaUser", newJString(quotaUser))
  add(query_589391, "alt", newJString(alt))
  add(query_589391, "oauth_token", newJString(oauthToken))
  add(query_589391, "callback", newJString(callback))
  add(query_589391, "access_token", newJString(accessToken))
  add(query_589391, "uploadType", newJString(uploadType))
  add(path_589390, "parent", newJString(parent))
  add(query_589391, "key", newJString(key))
  add(query_589391, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589392 = body
  add(query_589391, "prettyPrint", newJBool(prettyPrint))
  result = call_589389.call(path_589390, query_589391, nil, nil, body_589392)

var androiddeviceprovisioningCustomersDevicesRemoveConfiguration* = Call_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_589372(
    name: "androiddeviceprovisioningCustomersDevicesRemoveConfiguration",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/devices:removeConfiguration", validator: validate_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_589373,
    base: "/",
    url: url_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_589374,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesUnclaim_589393 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningCustomersDevicesUnclaim_589395(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/devices:unclaim")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersDevicesUnclaim_589394(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Unclaims a device from a customer and removes it from zero-touch
  ## enrollment.
  ## 
  ## After removing a device, a customer must contact their reseller to register
  ## the device into zero-touch enrollment again.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The customer managing the device. An API resource name in the
  ## format `customers/[CUSTOMER_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589396 = path.getOrDefault("parent")
  valid_589396 = validateParameter(valid_589396, JString, required = true,
                                 default = nil)
  if valid_589396 != nil:
    section.add "parent", valid_589396
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589397 = query.getOrDefault("upload_protocol")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "upload_protocol", valid_589397
  var valid_589398 = query.getOrDefault("fields")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "fields", valid_589398
  var valid_589399 = query.getOrDefault("quotaUser")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "quotaUser", valid_589399
  var valid_589400 = query.getOrDefault("alt")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = newJString("json"))
  if valid_589400 != nil:
    section.add "alt", valid_589400
  var valid_589401 = query.getOrDefault("oauth_token")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "oauth_token", valid_589401
  var valid_589402 = query.getOrDefault("callback")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = nil)
  if valid_589402 != nil:
    section.add "callback", valid_589402
  var valid_589403 = query.getOrDefault("access_token")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = nil)
  if valid_589403 != nil:
    section.add "access_token", valid_589403
  var valid_589404 = query.getOrDefault("uploadType")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "uploadType", valid_589404
  var valid_589405 = query.getOrDefault("key")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = nil)
  if valid_589405 != nil:
    section.add "key", valid_589405
  var valid_589406 = query.getOrDefault("$.xgafv")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = newJString("1"))
  if valid_589406 != nil:
    section.add "$.xgafv", valid_589406
  var valid_589407 = query.getOrDefault("prettyPrint")
  valid_589407 = validateParameter(valid_589407, JBool, required = false,
                                 default = newJBool(true))
  if valid_589407 != nil:
    section.add "prettyPrint", valid_589407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589409: Call_AndroiddeviceprovisioningCustomersDevicesUnclaim_589393;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unclaims a device from a customer and removes it from zero-touch
  ## enrollment.
  ## 
  ## After removing a device, a customer must contact their reseller to register
  ## the device into zero-touch enrollment again.
  ## 
  let valid = call_589409.validator(path, query, header, formData, body)
  let scheme = call_589409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589409.url(scheme.get, call_589409.host, call_589409.base,
                         call_589409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589409, url, valid)

proc call*(call_589410: Call_AndroiddeviceprovisioningCustomersDevicesUnclaim_589393;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningCustomersDevicesUnclaim
  ## Unclaims a device from a customer and removes it from zero-touch
  ## enrollment.
  ## 
  ## After removing a device, a customer must contact their reseller to register
  ## the device into zero-touch enrollment again.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The customer managing the device. An API resource name in the
  ## format `customers/[CUSTOMER_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589411 = newJObject()
  var query_589412 = newJObject()
  var body_589413 = newJObject()
  add(query_589412, "upload_protocol", newJString(uploadProtocol))
  add(query_589412, "fields", newJString(fields))
  add(query_589412, "quotaUser", newJString(quotaUser))
  add(query_589412, "alt", newJString(alt))
  add(query_589412, "oauth_token", newJString(oauthToken))
  add(query_589412, "callback", newJString(callback))
  add(query_589412, "access_token", newJString(accessToken))
  add(query_589412, "uploadType", newJString(uploadType))
  add(path_589411, "parent", newJString(parent))
  add(query_589412, "key", newJString(key))
  add(query_589412, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589413 = body
  add(query_589412, "prettyPrint", newJBool(prettyPrint))
  result = call_589410.call(path_589411, query_589412, nil, nil, body_589413)

var androiddeviceprovisioningCustomersDevicesUnclaim* = Call_AndroiddeviceprovisioningCustomersDevicesUnclaim_589393(
    name: "androiddeviceprovisioningCustomersDevicesUnclaim",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/devices:unclaim",
    validator: validate_AndroiddeviceprovisioningCustomersDevicesUnclaim_589394,
    base: "/", url: url_AndroiddeviceprovisioningCustomersDevicesUnclaim_589395,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDpcsList_589414 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningCustomersDpcsList_589416(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dpcs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersDpcsList_589415(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the DPCs (device policy controllers) that support zero-touch
  ## enrollment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The customer that can use the DPCs in configurations. An API
  ## resource name in the format `customers/[CUSTOMER_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589417 = path.getOrDefault("parent")
  valid_589417 = validateParameter(valid_589417, JString, required = true,
                                 default = nil)
  if valid_589417 != nil:
    section.add "parent", valid_589417
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589418 = query.getOrDefault("upload_protocol")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "upload_protocol", valid_589418
  var valid_589419 = query.getOrDefault("fields")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "fields", valid_589419
  var valid_589420 = query.getOrDefault("quotaUser")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "quotaUser", valid_589420
  var valid_589421 = query.getOrDefault("alt")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = newJString("json"))
  if valid_589421 != nil:
    section.add "alt", valid_589421
  var valid_589422 = query.getOrDefault("oauth_token")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "oauth_token", valid_589422
  var valid_589423 = query.getOrDefault("callback")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "callback", valid_589423
  var valid_589424 = query.getOrDefault("access_token")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "access_token", valid_589424
  var valid_589425 = query.getOrDefault("uploadType")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = nil)
  if valid_589425 != nil:
    section.add "uploadType", valid_589425
  var valid_589426 = query.getOrDefault("key")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = nil)
  if valid_589426 != nil:
    section.add "key", valid_589426
  var valid_589427 = query.getOrDefault("$.xgafv")
  valid_589427 = validateParameter(valid_589427, JString, required = false,
                                 default = newJString("1"))
  if valid_589427 != nil:
    section.add "$.xgafv", valid_589427
  var valid_589428 = query.getOrDefault("prettyPrint")
  valid_589428 = validateParameter(valid_589428, JBool, required = false,
                                 default = newJBool(true))
  if valid_589428 != nil:
    section.add "prettyPrint", valid_589428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589429: Call_AndroiddeviceprovisioningCustomersDpcsList_589414;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the DPCs (device policy controllers) that support zero-touch
  ## enrollment.
  ## 
  let valid = call_589429.validator(path, query, header, formData, body)
  let scheme = call_589429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589429.url(scheme.get, call_589429.host, call_589429.base,
                         call_589429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589429, url, valid)

proc call*(call_589430: Call_AndroiddeviceprovisioningCustomersDpcsList_589414;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningCustomersDpcsList
  ## Lists the DPCs (device policy controllers) that support zero-touch
  ## enrollment.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The customer that can use the DPCs in configurations. An API
  ## resource name in the format `customers/[CUSTOMER_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589431 = newJObject()
  var query_589432 = newJObject()
  add(query_589432, "upload_protocol", newJString(uploadProtocol))
  add(query_589432, "fields", newJString(fields))
  add(query_589432, "quotaUser", newJString(quotaUser))
  add(query_589432, "alt", newJString(alt))
  add(query_589432, "oauth_token", newJString(oauthToken))
  add(query_589432, "callback", newJString(callback))
  add(query_589432, "access_token", newJString(accessToken))
  add(query_589432, "uploadType", newJString(uploadType))
  add(path_589431, "parent", newJString(parent))
  add(query_589432, "key", newJString(key))
  add(query_589432, "$.xgafv", newJString(Xgafv))
  add(query_589432, "prettyPrint", newJBool(prettyPrint))
  result = call_589430.call(path_589431, query_589432, nil, nil, nil)

var androiddeviceprovisioningCustomersDpcsList* = Call_AndroiddeviceprovisioningCustomersDpcsList_589414(
    name: "androiddeviceprovisioningCustomersDpcsList", meth: HttpMethod.HttpGet,
    host: "androiddeviceprovisioning.googleapis.com", route: "/v1/{parent}/dpcs",
    validator: validate_AndroiddeviceprovisioningCustomersDpcsList_589415,
    base: "/", url: url_AndroiddeviceprovisioningCustomersDpcsList_589416,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersVendorsList_589433 = ref object of OpenApiRestCall_588441
proc url_AndroiddeviceprovisioningPartnersVendorsList_589435(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/vendors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersVendorsList_589434(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the vendors of the partner.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name in the format `partners/[PARTNER_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589436 = path.getOrDefault("parent")
  valid_589436 = validateParameter(valid_589436, JString, required = true,
                                 default = nil)
  if valid_589436 != nil:
    section.add "parent", valid_589436
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results returned by the server.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of results to be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589437 = query.getOrDefault("upload_protocol")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "upload_protocol", valid_589437
  var valid_589438 = query.getOrDefault("fields")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "fields", valid_589438
  var valid_589439 = query.getOrDefault("pageToken")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "pageToken", valid_589439
  var valid_589440 = query.getOrDefault("quotaUser")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = nil)
  if valid_589440 != nil:
    section.add "quotaUser", valid_589440
  var valid_589441 = query.getOrDefault("alt")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = newJString("json"))
  if valid_589441 != nil:
    section.add "alt", valid_589441
  var valid_589442 = query.getOrDefault("oauth_token")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "oauth_token", valid_589442
  var valid_589443 = query.getOrDefault("callback")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = nil)
  if valid_589443 != nil:
    section.add "callback", valid_589443
  var valid_589444 = query.getOrDefault("access_token")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = nil)
  if valid_589444 != nil:
    section.add "access_token", valid_589444
  var valid_589445 = query.getOrDefault("uploadType")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "uploadType", valid_589445
  var valid_589446 = query.getOrDefault("key")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "key", valid_589446
  var valid_589447 = query.getOrDefault("$.xgafv")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = newJString("1"))
  if valid_589447 != nil:
    section.add "$.xgafv", valid_589447
  var valid_589448 = query.getOrDefault("pageSize")
  valid_589448 = validateParameter(valid_589448, JInt, required = false, default = nil)
  if valid_589448 != nil:
    section.add "pageSize", valid_589448
  var valid_589449 = query.getOrDefault("prettyPrint")
  valid_589449 = validateParameter(valid_589449, JBool, required = false,
                                 default = newJBool(true))
  if valid_589449 != nil:
    section.add "prettyPrint", valid_589449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589450: Call_AndroiddeviceprovisioningPartnersVendorsList_589433;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the vendors of the partner.
  ## 
  let valid = call_589450.validator(path, query, header, formData, body)
  let scheme = call_589450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589450.url(scheme.get, call_589450.host, call_589450.base,
                         call_589450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589450, url, valid)

proc call*(call_589451: Call_AndroiddeviceprovisioningPartnersVendorsList_589433;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningPartnersVendorsList
  ## Lists the vendors of the partner.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results returned by the server.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The resource name in the format `partners/[PARTNER_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589452 = newJObject()
  var query_589453 = newJObject()
  add(query_589453, "upload_protocol", newJString(uploadProtocol))
  add(query_589453, "fields", newJString(fields))
  add(query_589453, "pageToken", newJString(pageToken))
  add(query_589453, "quotaUser", newJString(quotaUser))
  add(query_589453, "alt", newJString(alt))
  add(query_589453, "oauth_token", newJString(oauthToken))
  add(query_589453, "callback", newJString(callback))
  add(query_589453, "access_token", newJString(accessToken))
  add(query_589453, "uploadType", newJString(uploadType))
  add(path_589452, "parent", newJString(parent))
  add(query_589453, "key", newJString(key))
  add(query_589453, "$.xgafv", newJString(Xgafv))
  add(query_589453, "pageSize", newJInt(pageSize))
  add(query_589453, "prettyPrint", newJBool(prettyPrint))
  result = call_589451.call(path_589452, query_589453, nil, nil, nil)

var androiddeviceprovisioningPartnersVendorsList* = Call_AndroiddeviceprovisioningPartnersVendorsList_589433(
    name: "androiddeviceprovisioningPartnersVendorsList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/vendors",
    validator: validate_AndroiddeviceprovisioningPartnersVendorsList_589434,
    base: "/", url: url_AndroiddeviceprovisioningPartnersVendorsList_589435,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
