
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroiddeviceprovisioningCustomersList_597677 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningCustomersList_597679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AndroiddeviceprovisioningCustomersList_597678(path: JsonNode;
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
  var valid_597791 = query.getOrDefault("upload_protocol")
  valid_597791 = validateParameter(valid_597791, JString, required = false,
                                 default = nil)
  if valid_597791 != nil:
    section.add "upload_protocol", valid_597791
  var valid_597792 = query.getOrDefault("fields")
  valid_597792 = validateParameter(valid_597792, JString, required = false,
                                 default = nil)
  if valid_597792 != nil:
    section.add "fields", valid_597792
  var valid_597793 = query.getOrDefault("pageToken")
  valid_597793 = validateParameter(valid_597793, JString, required = false,
                                 default = nil)
  if valid_597793 != nil:
    section.add "pageToken", valid_597793
  var valid_597794 = query.getOrDefault("quotaUser")
  valid_597794 = validateParameter(valid_597794, JString, required = false,
                                 default = nil)
  if valid_597794 != nil:
    section.add "quotaUser", valid_597794
  var valid_597808 = query.getOrDefault("alt")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = newJString("json"))
  if valid_597808 != nil:
    section.add "alt", valid_597808
  var valid_597809 = query.getOrDefault("oauth_token")
  valid_597809 = validateParameter(valid_597809, JString, required = false,
                                 default = nil)
  if valid_597809 != nil:
    section.add "oauth_token", valid_597809
  var valid_597810 = query.getOrDefault("callback")
  valid_597810 = validateParameter(valid_597810, JString, required = false,
                                 default = nil)
  if valid_597810 != nil:
    section.add "callback", valid_597810
  var valid_597811 = query.getOrDefault("access_token")
  valid_597811 = validateParameter(valid_597811, JString, required = false,
                                 default = nil)
  if valid_597811 != nil:
    section.add "access_token", valid_597811
  var valid_597812 = query.getOrDefault("uploadType")
  valid_597812 = validateParameter(valid_597812, JString, required = false,
                                 default = nil)
  if valid_597812 != nil:
    section.add "uploadType", valid_597812
  var valid_597813 = query.getOrDefault("key")
  valid_597813 = validateParameter(valid_597813, JString, required = false,
                                 default = nil)
  if valid_597813 != nil:
    section.add "key", valid_597813
  var valid_597814 = query.getOrDefault("$.xgafv")
  valid_597814 = validateParameter(valid_597814, JString, required = false,
                                 default = newJString("1"))
  if valid_597814 != nil:
    section.add "$.xgafv", valid_597814
  var valid_597815 = query.getOrDefault("pageSize")
  valid_597815 = validateParameter(valid_597815, JInt, required = false, default = nil)
  if valid_597815 != nil:
    section.add "pageSize", valid_597815
  var valid_597816 = query.getOrDefault("prettyPrint")
  valid_597816 = validateParameter(valid_597816, JBool, required = false,
                                 default = newJBool(true))
  if valid_597816 != nil:
    section.add "prettyPrint", valid_597816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597839: Call_AndroiddeviceprovisioningCustomersList_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the user's customer accounts.
  ## 
  let valid = call_597839.validator(path, query, header, formData, body)
  let scheme = call_597839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597839.url(scheme.get, call_597839.host, call_597839.base,
                         call_597839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597839, url, valid)

proc call*(call_597910: Call_AndroiddeviceprovisioningCustomersList_597677;
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
  var query_597911 = newJObject()
  add(query_597911, "upload_protocol", newJString(uploadProtocol))
  add(query_597911, "fields", newJString(fields))
  add(query_597911, "pageToken", newJString(pageToken))
  add(query_597911, "quotaUser", newJString(quotaUser))
  add(query_597911, "alt", newJString(alt))
  add(query_597911, "oauth_token", newJString(oauthToken))
  add(query_597911, "callback", newJString(callback))
  add(query_597911, "access_token", newJString(accessToken))
  add(query_597911, "uploadType", newJString(uploadType))
  add(query_597911, "key", newJString(key))
  add(query_597911, "$.xgafv", newJString(Xgafv))
  add(query_597911, "pageSize", newJInt(pageSize))
  add(query_597911, "prettyPrint", newJBool(prettyPrint))
  result = call_597910.call(nil, query_597911, nil, nil, nil)

var androiddeviceprovisioningCustomersList* = Call_AndroiddeviceprovisioningCustomersList_597677(
    name: "androiddeviceprovisioningCustomersList", meth: HttpMethod.HttpGet,
    host: "androiddeviceprovisioning.googleapis.com", route: "/v1/customers",
    validator: validate_AndroiddeviceprovisioningCustomersList_597678, base: "/",
    url: url_AndroiddeviceprovisioningCustomersList_597679,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesMetadata_597951 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningPartnersDevicesMetadata_597953(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningPartnersDevicesMetadata_597952(
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
  var valid_597968 = path.getOrDefault("deviceId")
  valid_597968 = validateParameter(valid_597968, JString, required = true,
                                 default = nil)
  if valid_597968 != nil:
    section.add "deviceId", valid_597968
  var valid_597969 = path.getOrDefault("metadataOwnerId")
  valid_597969 = validateParameter(valid_597969, JString, required = true,
                                 default = nil)
  if valid_597969 != nil:
    section.add "metadataOwnerId", valid_597969
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
  var valid_597970 = query.getOrDefault("upload_protocol")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "upload_protocol", valid_597970
  var valid_597971 = query.getOrDefault("fields")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "fields", valid_597971
  var valid_597972 = query.getOrDefault("quotaUser")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "quotaUser", valid_597972
  var valid_597973 = query.getOrDefault("alt")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = newJString("json"))
  if valid_597973 != nil:
    section.add "alt", valid_597973
  var valid_597974 = query.getOrDefault("oauth_token")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "oauth_token", valid_597974
  var valid_597975 = query.getOrDefault("callback")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "callback", valid_597975
  var valid_597976 = query.getOrDefault("access_token")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "access_token", valid_597976
  var valid_597977 = query.getOrDefault("uploadType")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "uploadType", valid_597977
  var valid_597978 = query.getOrDefault("key")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "key", valid_597978
  var valid_597979 = query.getOrDefault("$.xgafv")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = newJString("1"))
  if valid_597979 != nil:
    section.add "$.xgafv", valid_597979
  var valid_597980 = query.getOrDefault("prettyPrint")
  valid_597980 = validateParameter(valid_597980, JBool, required = false,
                                 default = newJBool(true))
  if valid_597980 != nil:
    section.add "prettyPrint", valid_597980
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

proc call*(call_597982: Call_AndroiddeviceprovisioningPartnersDevicesMetadata_597951;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates reseller metadata associated with the device.
  ## 
  let valid = call_597982.validator(path, query, header, formData, body)
  let scheme = call_597982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597982.url(scheme.get, call_597982.host, call_597982.base,
                         call_597982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597982, url, valid)

proc call*(call_597983: Call_AndroiddeviceprovisioningPartnersDevicesMetadata_597951;
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
  var path_597984 = newJObject()
  var query_597985 = newJObject()
  var body_597986 = newJObject()
  add(query_597985, "upload_protocol", newJString(uploadProtocol))
  add(query_597985, "fields", newJString(fields))
  add(query_597985, "quotaUser", newJString(quotaUser))
  add(query_597985, "alt", newJString(alt))
  add(path_597984, "deviceId", newJString(deviceId))
  add(query_597985, "oauth_token", newJString(oauthToken))
  add(query_597985, "callback", newJString(callback))
  add(query_597985, "access_token", newJString(accessToken))
  add(query_597985, "uploadType", newJString(uploadType))
  add(query_597985, "key", newJString(key))
  add(path_597984, "metadataOwnerId", newJString(metadataOwnerId))
  add(query_597985, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597986 = body
  add(query_597985, "prettyPrint", newJBool(prettyPrint))
  result = call_597983.call(path_597984, query_597985, nil, nil, body_597986)

var androiddeviceprovisioningPartnersDevicesMetadata* = Call_AndroiddeviceprovisioningPartnersDevicesMetadata_597951(
    name: "androiddeviceprovisioningPartnersDevicesMetadata",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{metadataOwnerId}/devices/{deviceId}/metadata",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesMetadata_597952,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesMetadata_597953,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersCustomersList_597987 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningPartnersCustomersList_597989(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningPartnersCustomersList_597988(
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
  var valid_597990 = path.getOrDefault("partnerId")
  valid_597990 = validateParameter(valid_597990, JString, required = true,
                                 default = nil)
  if valid_597990 != nil:
    section.add "partnerId", valid_597990
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
  var valid_597991 = query.getOrDefault("upload_protocol")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "upload_protocol", valid_597991
  var valid_597992 = query.getOrDefault("fields")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "fields", valid_597992
  var valid_597993 = query.getOrDefault("pageToken")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "pageToken", valid_597993
  var valid_597994 = query.getOrDefault("quotaUser")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "quotaUser", valid_597994
  var valid_597995 = query.getOrDefault("alt")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = newJString("json"))
  if valid_597995 != nil:
    section.add "alt", valid_597995
  var valid_597996 = query.getOrDefault("oauth_token")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "oauth_token", valid_597996
  var valid_597997 = query.getOrDefault("callback")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "callback", valid_597997
  var valid_597998 = query.getOrDefault("access_token")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "access_token", valid_597998
  var valid_597999 = query.getOrDefault("uploadType")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "uploadType", valid_597999
  var valid_598000 = query.getOrDefault("key")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "key", valid_598000
  var valid_598001 = query.getOrDefault("$.xgafv")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = newJString("1"))
  if valid_598001 != nil:
    section.add "$.xgafv", valid_598001
  var valid_598002 = query.getOrDefault("pageSize")
  valid_598002 = validateParameter(valid_598002, JInt, required = false, default = nil)
  if valid_598002 != nil:
    section.add "pageSize", valid_598002
  var valid_598003 = query.getOrDefault("prettyPrint")
  valid_598003 = validateParameter(valid_598003, JBool, required = false,
                                 default = newJBool(true))
  if valid_598003 != nil:
    section.add "prettyPrint", valid_598003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598004: Call_AndroiddeviceprovisioningPartnersCustomersList_597987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the customers that are enrolled to the reseller identified by the
  ## `partnerId` argument. This list includes customers that the reseller
  ## created and customers that enrolled themselves using the portal.
  ## 
  let valid = call_598004.validator(path, query, header, formData, body)
  let scheme = call_598004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598004.url(scheme.get, call_598004.host, call_598004.base,
                         call_598004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598004, url, valid)

proc call*(call_598005: Call_AndroiddeviceprovisioningPartnersCustomersList_597987;
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
  var path_598006 = newJObject()
  var query_598007 = newJObject()
  add(query_598007, "upload_protocol", newJString(uploadProtocol))
  add(query_598007, "fields", newJString(fields))
  add(query_598007, "pageToken", newJString(pageToken))
  add(query_598007, "quotaUser", newJString(quotaUser))
  add(query_598007, "alt", newJString(alt))
  add(query_598007, "oauth_token", newJString(oauthToken))
  add(query_598007, "callback", newJString(callback))
  add(query_598007, "access_token", newJString(accessToken))
  add(query_598007, "uploadType", newJString(uploadType))
  add(query_598007, "key", newJString(key))
  add(query_598007, "$.xgafv", newJString(Xgafv))
  add(query_598007, "pageSize", newJInt(pageSize))
  add(query_598007, "prettyPrint", newJBool(prettyPrint))
  add(path_598006, "partnerId", newJString(partnerId))
  result = call_598005.call(path_598006, query_598007, nil, nil, nil)

var androiddeviceprovisioningPartnersCustomersList* = Call_AndroiddeviceprovisioningPartnersCustomersList_597987(
    name: "androiddeviceprovisioningPartnersCustomersList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/customers",
    validator: validate_AndroiddeviceprovisioningPartnersCustomersList_597988,
    base: "/", url: url_AndroiddeviceprovisioningPartnersCustomersList_597989,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesClaim_598008 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningPartnersDevicesClaim_598010(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningPartnersDevicesClaim_598009(
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
  var valid_598011 = path.getOrDefault("partnerId")
  valid_598011 = validateParameter(valid_598011, JString, required = true,
                                 default = nil)
  if valid_598011 != nil:
    section.add "partnerId", valid_598011
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
  var valid_598012 = query.getOrDefault("upload_protocol")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "upload_protocol", valid_598012
  var valid_598013 = query.getOrDefault("fields")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "fields", valid_598013
  var valid_598014 = query.getOrDefault("quotaUser")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "quotaUser", valid_598014
  var valid_598015 = query.getOrDefault("alt")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = newJString("json"))
  if valid_598015 != nil:
    section.add "alt", valid_598015
  var valid_598016 = query.getOrDefault("oauth_token")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "oauth_token", valid_598016
  var valid_598017 = query.getOrDefault("callback")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "callback", valid_598017
  var valid_598018 = query.getOrDefault("access_token")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "access_token", valid_598018
  var valid_598019 = query.getOrDefault("uploadType")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "uploadType", valid_598019
  var valid_598020 = query.getOrDefault("key")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "key", valid_598020
  var valid_598021 = query.getOrDefault("$.xgafv")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = newJString("1"))
  if valid_598021 != nil:
    section.add "$.xgafv", valid_598021
  var valid_598022 = query.getOrDefault("prettyPrint")
  valid_598022 = validateParameter(valid_598022, JBool, required = false,
                                 default = newJBool(true))
  if valid_598022 != nil:
    section.add "prettyPrint", valid_598022
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

proc call*(call_598024: Call_AndroiddeviceprovisioningPartnersDevicesClaim_598008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Claims a device for a customer and adds it to zero-touch enrollment. If the
  ## device is already claimed by another customer, the call returns an error.
  ## 
  let valid = call_598024.validator(path, query, header, formData, body)
  let scheme = call_598024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598024.url(scheme.get, call_598024.host, call_598024.base,
                         call_598024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598024, url, valid)

proc call*(call_598025: Call_AndroiddeviceprovisioningPartnersDevicesClaim_598008;
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
  var path_598026 = newJObject()
  var query_598027 = newJObject()
  var body_598028 = newJObject()
  add(query_598027, "upload_protocol", newJString(uploadProtocol))
  add(query_598027, "fields", newJString(fields))
  add(query_598027, "quotaUser", newJString(quotaUser))
  add(query_598027, "alt", newJString(alt))
  add(query_598027, "oauth_token", newJString(oauthToken))
  add(query_598027, "callback", newJString(callback))
  add(query_598027, "access_token", newJString(accessToken))
  add(query_598027, "uploadType", newJString(uploadType))
  add(query_598027, "key", newJString(key))
  add(query_598027, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598028 = body
  add(query_598027, "prettyPrint", newJBool(prettyPrint))
  add(path_598026, "partnerId", newJString(partnerId))
  result = call_598025.call(path_598026, query_598027, nil, nil, body_598028)

var androiddeviceprovisioningPartnersDevicesClaim* = Call_AndroiddeviceprovisioningPartnersDevicesClaim_598008(
    name: "androiddeviceprovisioningPartnersDevicesClaim",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:claim",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesClaim_598009,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesClaim_598010,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesClaimAsync_598029 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningPartnersDevicesClaimAsync_598031(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningPartnersDevicesClaimAsync_598030(
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
  var valid_598032 = path.getOrDefault("partnerId")
  valid_598032 = validateParameter(valid_598032, JString, required = true,
                                 default = nil)
  if valid_598032 != nil:
    section.add "partnerId", valid_598032
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
  var valid_598033 = query.getOrDefault("upload_protocol")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "upload_protocol", valid_598033
  var valid_598034 = query.getOrDefault("fields")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "fields", valid_598034
  var valid_598035 = query.getOrDefault("quotaUser")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "quotaUser", valid_598035
  var valid_598036 = query.getOrDefault("alt")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = newJString("json"))
  if valid_598036 != nil:
    section.add "alt", valid_598036
  var valid_598037 = query.getOrDefault("oauth_token")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "oauth_token", valid_598037
  var valid_598038 = query.getOrDefault("callback")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "callback", valid_598038
  var valid_598039 = query.getOrDefault("access_token")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "access_token", valid_598039
  var valid_598040 = query.getOrDefault("uploadType")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "uploadType", valid_598040
  var valid_598041 = query.getOrDefault("key")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = nil)
  if valid_598041 != nil:
    section.add "key", valid_598041
  var valid_598042 = query.getOrDefault("$.xgafv")
  valid_598042 = validateParameter(valid_598042, JString, required = false,
                                 default = newJString("1"))
  if valid_598042 != nil:
    section.add "$.xgafv", valid_598042
  var valid_598043 = query.getOrDefault("prettyPrint")
  valid_598043 = validateParameter(valid_598043, JBool, required = false,
                                 default = newJBool(true))
  if valid_598043 != nil:
    section.add "prettyPrint", valid_598043
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

proc call*(call_598045: Call_AndroiddeviceprovisioningPartnersDevicesClaimAsync_598029;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Claims a batch of devices for a customer asynchronously. Adds the devices
  ## to zero-touch enrollment. To learn more, read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ## 
  let valid = call_598045.validator(path, query, header, formData, body)
  let scheme = call_598045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598045.url(scheme.get, call_598045.host, call_598045.base,
                         call_598045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598045, url, valid)

proc call*(call_598046: Call_AndroiddeviceprovisioningPartnersDevicesClaimAsync_598029;
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
  var path_598047 = newJObject()
  var query_598048 = newJObject()
  var body_598049 = newJObject()
  add(query_598048, "upload_protocol", newJString(uploadProtocol))
  add(query_598048, "fields", newJString(fields))
  add(query_598048, "quotaUser", newJString(quotaUser))
  add(query_598048, "alt", newJString(alt))
  add(query_598048, "oauth_token", newJString(oauthToken))
  add(query_598048, "callback", newJString(callback))
  add(query_598048, "access_token", newJString(accessToken))
  add(query_598048, "uploadType", newJString(uploadType))
  add(query_598048, "key", newJString(key))
  add(query_598048, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598049 = body
  add(query_598048, "prettyPrint", newJBool(prettyPrint))
  add(path_598047, "partnerId", newJString(partnerId))
  result = call_598046.call(path_598047, query_598048, nil, nil, body_598049)

var androiddeviceprovisioningPartnersDevicesClaimAsync* = Call_AndroiddeviceprovisioningPartnersDevicesClaimAsync_598029(
    name: "androiddeviceprovisioningPartnersDevicesClaimAsync",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:claimAsync",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesClaimAsync_598030,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesClaimAsync_598031,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_598050 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_598052(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_598051(
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
  var valid_598053 = path.getOrDefault("partnerId")
  valid_598053 = validateParameter(valid_598053, JString, required = true,
                                 default = nil)
  if valid_598053 != nil:
    section.add "partnerId", valid_598053
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
  var valid_598054 = query.getOrDefault("upload_protocol")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "upload_protocol", valid_598054
  var valid_598055 = query.getOrDefault("fields")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "fields", valid_598055
  var valid_598056 = query.getOrDefault("quotaUser")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "quotaUser", valid_598056
  var valid_598057 = query.getOrDefault("alt")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = newJString("json"))
  if valid_598057 != nil:
    section.add "alt", valid_598057
  var valid_598058 = query.getOrDefault("oauth_token")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "oauth_token", valid_598058
  var valid_598059 = query.getOrDefault("callback")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "callback", valid_598059
  var valid_598060 = query.getOrDefault("access_token")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "access_token", valid_598060
  var valid_598061 = query.getOrDefault("uploadType")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "uploadType", valid_598061
  var valid_598062 = query.getOrDefault("key")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = nil)
  if valid_598062 != nil:
    section.add "key", valid_598062
  var valid_598063 = query.getOrDefault("$.xgafv")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = newJString("1"))
  if valid_598063 != nil:
    section.add "$.xgafv", valid_598063
  var valid_598064 = query.getOrDefault("prettyPrint")
  valid_598064 = validateParameter(valid_598064, JBool, required = false,
                                 default = newJBool(true))
  if valid_598064 != nil:
    section.add "prettyPrint", valid_598064
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

proc call*(call_598066: Call_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_598050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Finds devices by hardware identifiers, such as IMEI.
  ## 
  let valid = call_598066.validator(path, query, header, formData, body)
  let scheme = call_598066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598066.url(scheme.get, call_598066.host, call_598066.base,
                         call_598066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598066, url, valid)

proc call*(call_598067: Call_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_598050;
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
  var path_598068 = newJObject()
  var query_598069 = newJObject()
  var body_598070 = newJObject()
  add(query_598069, "upload_protocol", newJString(uploadProtocol))
  add(query_598069, "fields", newJString(fields))
  add(query_598069, "quotaUser", newJString(quotaUser))
  add(query_598069, "alt", newJString(alt))
  add(query_598069, "oauth_token", newJString(oauthToken))
  add(query_598069, "callback", newJString(callback))
  add(query_598069, "access_token", newJString(accessToken))
  add(query_598069, "uploadType", newJString(uploadType))
  add(query_598069, "key", newJString(key))
  add(query_598069, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598070 = body
  add(query_598069, "prettyPrint", newJBool(prettyPrint))
  add(path_598068, "partnerId", newJString(partnerId))
  result = call_598067.call(path_598068, query_598069, nil, nil, body_598070)

var androiddeviceprovisioningPartnersDevicesFindByIdentifier* = Call_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_598050(
    name: "androiddeviceprovisioningPartnersDevicesFindByIdentifier",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:findByIdentifier", validator: validate_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_598051,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_598052,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesFindByOwner_598071 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningPartnersDevicesFindByOwner_598073(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningPartnersDevicesFindByOwner_598072(
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
  var valid_598074 = path.getOrDefault("partnerId")
  valid_598074 = validateParameter(valid_598074, JString, required = true,
                                 default = nil)
  if valid_598074 != nil:
    section.add "partnerId", valid_598074
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
  var valid_598075 = query.getOrDefault("upload_protocol")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "upload_protocol", valid_598075
  var valid_598076 = query.getOrDefault("fields")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "fields", valid_598076
  var valid_598077 = query.getOrDefault("quotaUser")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "quotaUser", valid_598077
  var valid_598078 = query.getOrDefault("alt")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = newJString("json"))
  if valid_598078 != nil:
    section.add "alt", valid_598078
  var valid_598079 = query.getOrDefault("oauth_token")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "oauth_token", valid_598079
  var valid_598080 = query.getOrDefault("callback")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "callback", valid_598080
  var valid_598081 = query.getOrDefault("access_token")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "access_token", valid_598081
  var valid_598082 = query.getOrDefault("uploadType")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "uploadType", valid_598082
  var valid_598083 = query.getOrDefault("key")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "key", valid_598083
  var valid_598084 = query.getOrDefault("$.xgafv")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = newJString("1"))
  if valid_598084 != nil:
    section.add "$.xgafv", valid_598084
  var valid_598085 = query.getOrDefault("prettyPrint")
  valid_598085 = validateParameter(valid_598085, JBool, required = false,
                                 default = newJBool(true))
  if valid_598085 != nil:
    section.add "prettyPrint", valid_598085
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

proc call*(call_598087: Call_AndroiddeviceprovisioningPartnersDevicesFindByOwner_598071;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Finds devices claimed for customers. The results only contain devices
  ## registered to the reseller that's identified by the `partnerId` argument.
  ## The customer's devices purchased from other resellers don't appear in the
  ## results.
  ## 
  let valid = call_598087.validator(path, query, header, formData, body)
  let scheme = call_598087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598087.url(scheme.get, call_598087.host, call_598087.base,
                         call_598087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598087, url, valid)

proc call*(call_598088: Call_AndroiddeviceprovisioningPartnersDevicesFindByOwner_598071;
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
  var path_598089 = newJObject()
  var query_598090 = newJObject()
  var body_598091 = newJObject()
  add(query_598090, "upload_protocol", newJString(uploadProtocol))
  add(query_598090, "fields", newJString(fields))
  add(query_598090, "quotaUser", newJString(quotaUser))
  add(query_598090, "alt", newJString(alt))
  add(query_598090, "oauth_token", newJString(oauthToken))
  add(query_598090, "callback", newJString(callback))
  add(query_598090, "access_token", newJString(accessToken))
  add(query_598090, "uploadType", newJString(uploadType))
  add(query_598090, "key", newJString(key))
  add(query_598090, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598091 = body
  add(query_598090, "prettyPrint", newJBool(prettyPrint))
  add(path_598089, "partnerId", newJString(partnerId))
  result = call_598088.call(path_598089, query_598090, nil, nil, body_598091)

var androiddeviceprovisioningPartnersDevicesFindByOwner* = Call_AndroiddeviceprovisioningPartnersDevicesFindByOwner_598071(
    name: "androiddeviceprovisioningPartnersDevicesFindByOwner",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:findByOwner",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesFindByOwner_598072,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesFindByOwner_598073,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesUnclaim_598092 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningPartnersDevicesUnclaim_598094(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningPartnersDevicesUnclaim_598093(
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
  var valid_598095 = path.getOrDefault("partnerId")
  valid_598095 = validateParameter(valid_598095, JString, required = true,
                                 default = nil)
  if valid_598095 != nil:
    section.add "partnerId", valid_598095
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
  var valid_598096 = query.getOrDefault("upload_protocol")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "upload_protocol", valid_598096
  var valid_598097 = query.getOrDefault("fields")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "fields", valid_598097
  var valid_598098 = query.getOrDefault("quotaUser")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "quotaUser", valid_598098
  var valid_598099 = query.getOrDefault("alt")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = newJString("json"))
  if valid_598099 != nil:
    section.add "alt", valid_598099
  var valid_598100 = query.getOrDefault("oauth_token")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "oauth_token", valid_598100
  var valid_598101 = query.getOrDefault("callback")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "callback", valid_598101
  var valid_598102 = query.getOrDefault("access_token")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "access_token", valid_598102
  var valid_598103 = query.getOrDefault("uploadType")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = nil)
  if valid_598103 != nil:
    section.add "uploadType", valid_598103
  var valid_598104 = query.getOrDefault("key")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = nil)
  if valid_598104 != nil:
    section.add "key", valid_598104
  var valid_598105 = query.getOrDefault("$.xgafv")
  valid_598105 = validateParameter(valid_598105, JString, required = false,
                                 default = newJString("1"))
  if valid_598105 != nil:
    section.add "$.xgafv", valid_598105
  var valid_598106 = query.getOrDefault("prettyPrint")
  valid_598106 = validateParameter(valid_598106, JBool, required = false,
                                 default = newJBool(true))
  if valid_598106 != nil:
    section.add "prettyPrint", valid_598106
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

proc call*(call_598108: Call_AndroiddeviceprovisioningPartnersDevicesUnclaim_598092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unclaims a device from a customer and removes it from zero-touch
  ## enrollment.
  ## 
  let valid = call_598108.validator(path, query, header, formData, body)
  let scheme = call_598108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598108.url(scheme.get, call_598108.host, call_598108.base,
                         call_598108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598108, url, valid)

proc call*(call_598109: Call_AndroiddeviceprovisioningPartnersDevicesUnclaim_598092;
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
  var path_598110 = newJObject()
  var query_598111 = newJObject()
  var body_598112 = newJObject()
  add(query_598111, "upload_protocol", newJString(uploadProtocol))
  add(query_598111, "fields", newJString(fields))
  add(query_598111, "quotaUser", newJString(quotaUser))
  add(query_598111, "alt", newJString(alt))
  add(query_598111, "oauth_token", newJString(oauthToken))
  add(query_598111, "callback", newJString(callback))
  add(query_598111, "access_token", newJString(accessToken))
  add(query_598111, "uploadType", newJString(uploadType))
  add(query_598111, "key", newJString(key))
  add(query_598111, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598112 = body
  add(query_598111, "prettyPrint", newJBool(prettyPrint))
  add(path_598110, "partnerId", newJString(partnerId))
  result = call_598109.call(path_598110, query_598111, nil, nil, body_598112)

var androiddeviceprovisioningPartnersDevicesUnclaim* = Call_AndroiddeviceprovisioningPartnersDevicesUnclaim_598092(
    name: "androiddeviceprovisioningPartnersDevicesUnclaim",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:unclaim",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesUnclaim_598093,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesUnclaim_598094,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_598113 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_598115(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_598114(
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
  var valid_598116 = path.getOrDefault("partnerId")
  valid_598116 = validateParameter(valid_598116, JString, required = true,
                                 default = nil)
  if valid_598116 != nil:
    section.add "partnerId", valid_598116
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
  var valid_598117 = query.getOrDefault("upload_protocol")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "upload_protocol", valid_598117
  var valid_598118 = query.getOrDefault("fields")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "fields", valid_598118
  var valid_598119 = query.getOrDefault("quotaUser")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "quotaUser", valid_598119
  var valid_598120 = query.getOrDefault("alt")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = newJString("json"))
  if valid_598120 != nil:
    section.add "alt", valid_598120
  var valid_598121 = query.getOrDefault("oauth_token")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "oauth_token", valid_598121
  var valid_598122 = query.getOrDefault("callback")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "callback", valid_598122
  var valid_598123 = query.getOrDefault("access_token")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "access_token", valid_598123
  var valid_598124 = query.getOrDefault("uploadType")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "uploadType", valid_598124
  var valid_598125 = query.getOrDefault("key")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "key", valid_598125
  var valid_598126 = query.getOrDefault("$.xgafv")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = newJString("1"))
  if valid_598126 != nil:
    section.add "$.xgafv", valid_598126
  var valid_598127 = query.getOrDefault("prettyPrint")
  valid_598127 = validateParameter(valid_598127, JBool, required = false,
                                 default = newJBool(true))
  if valid_598127 != nil:
    section.add "prettyPrint", valid_598127
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

proc call*(call_598129: Call_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_598113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unclaims a batch of devices for a customer asynchronously. Removes the
  ## devices from zero-touch enrollment. To learn more, read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ## 
  let valid = call_598129.validator(path, query, header, formData, body)
  let scheme = call_598129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598129.url(scheme.get, call_598129.host, call_598129.base,
                         call_598129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598129, url, valid)

proc call*(call_598130: Call_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_598113;
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
  var path_598131 = newJObject()
  var query_598132 = newJObject()
  var body_598133 = newJObject()
  add(query_598132, "upload_protocol", newJString(uploadProtocol))
  add(query_598132, "fields", newJString(fields))
  add(query_598132, "quotaUser", newJString(quotaUser))
  add(query_598132, "alt", newJString(alt))
  add(query_598132, "oauth_token", newJString(oauthToken))
  add(query_598132, "callback", newJString(callback))
  add(query_598132, "access_token", newJString(accessToken))
  add(query_598132, "uploadType", newJString(uploadType))
  add(query_598132, "key", newJString(key))
  add(query_598132, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598133 = body
  add(query_598132, "prettyPrint", newJBool(prettyPrint))
  add(path_598131, "partnerId", newJString(partnerId))
  result = call_598130.call(path_598131, query_598132, nil, nil, body_598133)

var androiddeviceprovisioningPartnersDevicesUnclaimAsync* = Call_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_598113(
    name: "androiddeviceprovisioningPartnersDevicesUnclaimAsync",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:unclaimAsync",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_598114,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_598115,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_598134 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_598136(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_598135(
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
  var valid_598137 = path.getOrDefault("partnerId")
  valid_598137 = validateParameter(valid_598137, JString, required = true,
                                 default = nil)
  if valid_598137 != nil:
    section.add "partnerId", valid_598137
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
  var valid_598138 = query.getOrDefault("upload_protocol")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "upload_protocol", valid_598138
  var valid_598139 = query.getOrDefault("fields")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "fields", valid_598139
  var valid_598140 = query.getOrDefault("quotaUser")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "quotaUser", valid_598140
  var valid_598141 = query.getOrDefault("alt")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = newJString("json"))
  if valid_598141 != nil:
    section.add "alt", valid_598141
  var valid_598142 = query.getOrDefault("oauth_token")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "oauth_token", valid_598142
  var valid_598143 = query.getOrDefault("callback")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "callback", valid_598143
  var valid_598144 = query.getOrDefault("access_token")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "access_token", valid_598144
  var valid_598145 = query.getOrDefault("uploadType")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "uploadType", valid_598145
  var valid_598146 = query.getOrDefault("key")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = nil)
  if valid_598146 != nil:
    section.add "key", valid_598146
  var valid_598147 = query.getOrDefault("$.xgafv")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = newJString("1"))
  if valid_598147 != nil:
    section.add "$.xgafv", valid_598147
  var valid_598148 = query.getOrDefault("prettyPrint")
  valid_598148 = validateParameter(valid_598148, JBool, required = false,
                                 default = newJBool(true))
  if valid_598148 != nil:
    section.add "prettyPrint", valid_598148
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

proc call*(call_598150: Call_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_598134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the reseller metadata attached to a batch of devices. This method
  ## updates devices asynchronously and returns an `Operation` that can be used
  ## to track progress. Read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ## 
  let valid = call_598150.validator(path, query, header, formData, body)
  let scheme = call_598150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598150.url(scheme.get, call_598150.host, call_598150.base,
                         call_598150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598150, url, valid)

proc call*(call_598151: Call_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_598134;
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
  var path_598152 = newJObject()
  var query_598153 = newJObject()
  var body_598154 = newJObject()
  add(query_598153, "upload_protocol", newJString(uploadProtocol))
  add(query_598153, "fields", newJString(fields))
  add(query_598153, "quotaUser", newJString(quotaUser))
  add(query_598153, "alt", newJString(alt))
  add(query_598153, "oauth_token", newJString(oauthToken))
  add(query_598153, "callback", newJString(callback))
  add(query_598153, "access_token", newJString(accessToken))
  add(query_598153, "uploadType", newJString(uploadType))
  add(query_598153, "key", newJString(key))
  add(query_598153, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598154 = body
  add(query_598153, "prettyPrint", newJBool(prettyPrint))
  add(path_598152, "partnerId", newJString(partnerId))
  result = call_598151.call(path_598152, query_598153, nil, nil, body_598154)

var androiddeviceprovisioningPartnersDevicesUpdateMetadataAsync* = Call_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_598134(
    name: "androiddeviceprovisioningPartnersDevicesUpdateMetadataAsync",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:updateMetadataAsync", validator: validate_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_598135,
    base: "/",
    url: url_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_598136,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningOperationsGet_598155 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningOperationsGet_598157(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningOperationsGet_598156(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_598158 = path.getOrDefault("name")
  valid_598158 = validateParameter(valid_598158, JString, required = true,
                                 default = nil)
  if valid_598158 != nil:
    section.add "name", valid_598158
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
  var valid_598159 = query.getOrDefault("upload_protocol")
  valid_598159 = validateParameter(valid_598159, JString, required = false,
                                 default = nil)
  if valid_598159 != nil:
    section.add "upload_protocol", valid_598159
  var valid_598160 = query.getOrDefault("fields")
  valid_598160 = validateParameter(valid_598160, JString, required = false,
                                 default = nil)
  if valid_598160 != nil:
    section.add "fields", valid_598160
  var valid_598161 = query.getOrDefault("quotaUser")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "quotaUser", valid_598161
  var valid_598162 = query.getOrDefault("alt")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = newJString("json"))
  if valid_598162 != nil:
    section.add "alt", valid_598162
  var valid_598163 = query.getOrDefault("oauth_token")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "oauth_token", valid_598163
  var valid_598164 = query.getOrDefault("callback")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = nil)
  if valid_598164 != nil:
    section.add "callback", valid_598164
  var valid_598165 = query.getOrDefault("access_token")
  valid_598165 = validateParameter(valid_598165, JString, required = false,
                                 default = nil)
  if valid_598165 != nil:
    section.add "access_token", valid_598165
  var valid_598166 = query.getOrDefault("uploadType")
  valid_598166 = validateParameter(valid_598166, JString, required = false,
                                 default = nil)
  if valid_598166 != nil:
    section.add "uploadType", valid_598166
  var valid_598167 = query.getOrDefault("key")
  valid_598167 = validateParameter(valid_598167, JString, required = false,
                                 default = nil)
  if valid_598167 != nil:
    section.add "key", valid_598167
  var valid_598168 = query.getOrDefault("$.xgafv")
  valid_598168 = validateParameter(valid_598168, JString, required = false,
                                 default = newJString("1"))
  if valid_598168 != nil:
    section.add "$.xgafv", valid_598168
  var valid_598169 = query.getOrDefault("prettyPrint")
  valid_598169 = validateParameter(valid_598169, JBool, required = false,
                                 default = newJBool(true))
  if valid_598169 != nil:
    section.add "prettyPrint", valid_598169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598170: Call_AndroiddeviceprovisioningOperationsGet_598155;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_598170.validator(path, query, header, formData, body)
  let scheme = call_598170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598170.url(scheme.get, call_598170.host, call_598170.base,
                         call_598170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598170, url, valid)

proc call*(call_598171: Call_AndroiddeviceprovisioningOperationsGet_598155;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## androiddeviceprovisioningOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
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
  var path_598172 = newJObject()
  var query_598173 = newJObject()
  add(query_598173, "upload_protocol", newJString(uploadProtocol))
  add(query_598173, "fields", newJString(fields))
  add(query_598173, "quotaUser", newJString(quotaUser))
  add(path_598172, "name", newJString(name))
  add(query_598173, "alt", newJString(alt))
  add(query_598173, "oauth_token", newJString(oauthToken))
  add(query_598173, "callback", newJString(callback))
  add(query_598173, "access_token", newJString(accessToken))
  add(query_598173, "uploadType", newJString(uploadType))
  add(query_598173, "key", newJString(key))
  add(query_598173, "$.xgafv", newJString(Xgafv))
  add(query_598173, "prettyPrint", newJBool(prettyPrint))
  result = call_598171.call(path_598172, query_598173, nil, nil, nil)

var androiddeviceprovisioningOperationsGet* = Call_AndroiddeviceprovisioningOperationsGet_598155(
    name: "androiddeviceprovisioningOperationsGet", meth: HttpMethod.HttpGet,
    host: "androiddeviceprovisioning.googleapis.com", route: "/v1/{name}",
    validator: validate_AndroiddeviceprovisioningOperationsGet_598156, base: "/",
    url: url_AndroiddeviceprovisioningOperationsGet_598157,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersConfigurationsPatch_598193 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningCustomersConfigurationsPatch_598195(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersConfigurationsPatch_598194(
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
  var valid_598196 = path.getOrDefault("name")
  valid_598196 = validateParameter(valid_598196, JString, required = true,
                                 default = nil)
  if valid_598196 != nil:
    section.add "name", valid_598196
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
  var valid_598197 = query.getOrDefault("upload_protocol")
  valid_598197 = validateParameter(valid_598197, JString, required = false,
                                 default = nil)
  if valid_598197 != nil:
    section.add "upload_protocol", valid_598197
  var valid_598198 = query.getOrDefault("fields")
  valid_598198 = validateParameter(valid_598198, JString, required = false,
                                 default = nil)
  if valid_598198 != nil:
    section.add "fields", valid_598198
  var valid_598199 = query.getOrDefault("quotaUser")
  valid_598199 = validateParameter(valid_598199, JString, required = false,
                                 default = nil)
  if valid_598199 != nil:
    section.add "quotaUser", valid_598199
  var valid_598200 = query.getOrDefault("alt")
  valid_598200 = validateParameter(valid_598200, JString, required = false,
                                 default = newJString("json"))
  if valid_598200 != nil:
    section.add "alt", valid_598200
  var valid_598201 = query.getOrDefault("oauth_token")
  valid_598201 = validateParameter(valid_598201, JString, required = false,
                                 default = nil)
  if valid_598201 != nil:
    section.add "oauth_token", valid_598201
  var valid_598202 = query.getOrDefault("callback")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = nil)
  if valid_598202 != nil:
    section.add "callback", valid_598202
  var valid_598203 = query.getOrDefault("access_token")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "access_token", valid_598203
  var valid_598204 = query.getOrDefault("uploadType")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = nil)
  if valid_598204 != nil:
    section.add "uploadType", valid_598204
  var valid_598205 = query.getOrDefault("key")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = nil)
  if valid_598205 != nil:
    section.add "key", valid_598205
  var valid_598206 = query.getOrDefault("$.xgafv")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = newJString("1"))
  if valid_598206 != nil:
    section.add "$.xgafv", valid_598206
  var valid_598207 = query.getOrDefault("prettyPrint")
  valid_598207 = validateParameter(valid_598207, JBool, required = false,
                                 default = newJBool(true))
  if valid_598207 != nil:
    section.add "prettyPrint", valid_598207
  var valid_598208 = query.getOrDefault("updateMask")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = nil)
  if valid_598208 != nil:
    section.add "updateMask", valid_598208
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

proc call*(call_598210: Call_AndroiddeviceprovisioningCustomersConfigurationsPatch_598193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a configuration's field values.
  ## 
  let valid = call_598210.validator(path, query, header, formData, body)
  let scheme = call_598210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598210.url(scheme.get, call_598210.host, call_598210.base,
                         call_598210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598210, url, valid)

proc call*(call_598211: Call_AndroiddeviceprovisioningCustomersConfigurationsPatch_598193;
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
  var path_598212 = newJObject()
  var query_598213 = newJObject()
  var body_598214 = newJObject()
  add(query_598213, "upload_protocol", newJString(uploadProtocol))
  add(query_598213, "fields", newJString(fields))
  add(query_598213, "quotaUser", newJString(quotaUser))
  add(path_598212, "name", newJString(name))
  add(query_598213, "alt", newJString(alt))
  add(query_598213, "oauth_token", newJString(oauthToken))
  add(query_598213, "callback", newJString(callback))
  add(query_598213, "access_token", newJString(accessToken))
  add(query_598213, "uploadType", newJString(uploadType))
  add(query_598213, "key", newJString(key))
  add(query_598213, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598214 = body
  add(query_598213, "prettyPrint", newJBool(prettyPrint))
  add(query_598213, "updateMask", newJString(updateMask))
  result = call_598211.call(path_598212, query_598213, nil, nil, body_598214)

var androiddeviceprovisioningCustomersConfigurationsPatch* = Call_AndroiddeviceprovisioningCustomersConfigurationsPatch_598193(
    name: "androiddeviceprovisioningCustomersConfigurationsPatch",
    meth: HttpMethod.HttpPatch, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AndroiddeviceprovisioningCustomersConfigurationsPatch_598194,
    base: "/", url: url_AndroiddeviceprovisioningCustomersConfigurationsPatch_598195,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersConfigurationsDelete_598174 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningCustomersConfigurationsDelete_598176(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersConfigurationsDelete_598175(
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
  var valid_598177 = path.getOrDefault("name")
  valid_598177 = validateParameter(valid_598177, JString, required = true,
                                 default = nil)
  if valid_598177 != nil:
    section.add "name", valid_598177
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
  var valid_598178 = query.getOrDefault("upload_protocol")
  valid_598178 = validateParameter(valid_598178, JString, required = false,
                                 default = nil)
  if valid_598178 != nil:
    section.add "upload_protocol", valid_598178
  var valid_598179 = query.getOrDefault("fields")
  valid_598179 = validateParameter(valid_598179, JString, required = false,
                                 default = nil)
  if valid_598179 != nil:
    section.add "fields", valid_598179
  var valid_598180 = query.getOrDefault("quotaUser")
  valid_598180 = validateParameter(valid_598180, JString, required = false,
                                 default = nil)
  if valid_598180 != nil:
    section.add "quotaUser", valid_598180
  var valid_598181 = query.getOrDefault("alt")
  valid_598181 = validateParameter(valid_598181, JString, required = false,
                                 default = newJString("json"))
  if valid_598181 != nil:
    section.add "alt", valid_598181
  var valid_598182 = query.getOrDefault("oauth_token")
  valid_598182 = validateParameter(valid_598182, JString, required = false,
                                 default = nil)
  if valid_598182 != nil:
    section.add "oauth_token", valid_598182
  var valid_598183 = query.getOrDefault("callback")
  valid_598183 = validateParameter(valid_598183, JString, required = false,
                                 default = nil)
  if valid_598183 != nil:
    section.add "callback", valid_598183
  var valid_598184 = query.getOrDefault("access_token")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "access_token", valid_598184
  var valid_598185 = query.getOrDefault("uploadType")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = nil)
  if valid_598185 != nil:
    section.add "uploadType", valid_598185
  var valid_598186 = query.getOrDefault("key")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = nil)
  if valid_598186 != nil:
    section.add "key", valid_598186
  var valid_598187 = query.getOrDefault("$.xgafv")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = newJString("1"))
  if valid_598187 != nil:
    section.add "$.xgafv", valid_598187
  var valid_598188 = query.getOrDefault("prettyPrint")
  valid_598188 = validateParameter(valid_598188, JBool, required = false,
                                 default = newJBool(true))
  if valid_598188 != nil:
    section.add "prettyPrint", valid_598188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598189: Call_AndroiddeviceprovisioningCustomersConfigurationsDelete_598174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an unused configuration. The API call fails if the customer has
  ## devices with the configuration applied.
  ## 
  let valid = call_598189.validator(path, query, header, formData, body)
  let scheme = call_598189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598189.url(scheme.get, call_598189.host, call_598189.base,
                         call_598189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598189, url, valid)

proc call*(call_598190: Call_AndroiddeviceprovisioningCustomersConfigurationsDelete_598174;
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
  var path_598191 = newJObject()
  var query_598192 = newJObject()
  add(query_598192, "upload_protocol", newJString(uploadProtocol))
  add(query_598192, "fields", newJString(fields))
  add(query_598192, "quotaUser", newJString(quotaUser))
  add(path_598191, "name", newJString(name))
  add(query_598192, "alt", newJString(alt))
  add(query_598192, "oauth_token", newJString(oauthToken))
  add(query_598192, "callback", newJString(callback))
  add(query_598192, "access_token", newJString(accessToken))
  add(query_598192, "uploadType", newJString(uploadType))
  add(query_598192, "key", newJString(key))
  add(query_598192, "$.xgafv", newJString(Xgafv))
  add(query_598192, "prettyPrint", newJBool(prettyPrint))
  result = call_598190.call(path_598191, query_598192, nil, nil, nil)

var androiddeviceprovisioningCustomersConfigurationsDelete* = Call_AndroiddeviceprovisioningCustomersConfigurationsDelete_598174(
    name: "androiddeviceprovisioningCustomersConfigurationsDelete",
    meth: HttpMethod.HttpDelete, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AndroiddeviceprovisioningCustomersConfigurationsDelete_598175,
    base: "/", url: url_AndroiddeviceprovisioningCustomersConfigurationsDelete_598176,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersConfigurationsCreate_598234 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningCustomersConfigurationsCreate_598236(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningCustomersConfigurationsCreate_598235(
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
  var valid_598237 = path.getOrDefault("parent")
  valid_598237 = validateParameter(valid_598237, JString, required = true,
                                 default = nil)
  if valid_598237 != nil:
    section.add "parent", valid_598237
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
  var valid_598238 = query.getOrDefault("upload_protocol")
  valid_598238 = validateParameter(valid_598238, JString, required = false,
                                 default = nil)
  if valid_598238 != nil:
    section.add "upload_protocol", valid_598238
  var valid_598239 = query.getOrDefault("fields")
  valid_598239 = validateParameter(valid_598239, JString, required = false,
                                 default = nil)
  if valid_598239 != nil:
    section.add "fields", valid_598239
  var valid_598240 = query.getOrDefault("quotaUser")
  valid_598240 = validateParameter(valid_598240, JString, required = false,
                                 default = nil)
  if valid_598240 != nil:
    section.add "quotaUser", valid_598240
  var valid_598241 = query.getOrDefault("alt")
  valid_598241 = validateParameter(valid_598241, JString, required = false,
                                 default = newJString("json"))
  if valid_598241 != nil:
    section.add "alt", valid_598241
  var valid_598242 = query.getOrDefault("oauth_token")
  valid_598242 = validateParameter(valid_598242, JString, required = false,
                                 default = nil)
  if valid_598242 != nil:
    section.add "oauth_token", valid_598242
  var valid_598243 = query.getOrDefault("callback")
  valid_598243 = validateParameter(valid_598243, JString, required = false,
                                 default = nil)
  if valid_598243 != nil:
    section.add "callback", valid_598243
  var valid_598244 = query.getOrDefault("access_token")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = nil)
  if valid_598244 != nil:
    section.add "access_token", valid_598244
  var valid_598245 = query.getOrDefault("uploadType")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = nil)
  if valid_598245 != nil:
    section.add "uploadType", valid_598245
  var valid_598246 = query.getOrDefault("key")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = nil)
  if valid_598246 != nil:
    section.add "key", valid_598246
  var valid_598247 = query.getOrDefault("$.xgafv")
  valid_598247 = validateParameter(valid_598247, JString, required = false,
                                 default = newJString("1"))
  if valid_598247 != nil:
    section.add "$.xgafv", valid_598247
  var valid_598248 = query.getOrDefault("prettyPrint")
  valid_598248 = validateParameter(valid_598248, JBool, required = false,
                                 default = newJBool(true))
  if valid_598248 != nil:
    section.add "prettyPrint", valid_598248
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

proc call*(call_598250: Call_AndroiddeviceprovisioningCustomersConfigurationsCreate_598234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new configuration. Once created, a customer can apply the
  ## configuration to devices.
  ## 
  let valid = call_598250.validator(path, query, header, formData, body)
  let scheme = call_598250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598250.url(scheme.get, call_598250.host, call_598250.base,
                         call_598250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598250, url, valid)

proc call*(call_598251: Call_AndroiddeviceprovisioningCustomersConfigurationsCreate_598234;
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
  var path_598252 = newJObject()
  var query_598253 = newJObject()
  var body_598254 = newJObject()
  add(query_598253, "upload_protocol", newJString(uploadProtocol))
  add(query_598253, "fields", newJString(fields))
  add(query_598253, "quotaUser", newJString(quotaUser))
  add(query_598253, "alt", newJString(alt))
  add(query_598253, "oauth_token", newJString(oauthToken))
  add(query_598253, "callback", newJString(callback))
  add(query_598253, "access_token", newJString(accessToken))
  add(query_598253, "uploadType", newJString(uploadType))
  add(path_598252, "parent", newJString(parent))
  add(query_598253, "key", newJString(key))
  add(query_598253, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598254 = body
  add(query_598253, "prettyPrint", newJBool(prettyPrint))
  result = call_598251.call(path_598252, query_598253, nil, nil, body_598254)

var androiddeviceprovisioningCustomersConfigurationsCreate* = Call_AndroiddeviceprovisioningCustomersConfigurationsCreate_598234(
    name: "androiddeviceprovisioningCustomersConfigurationsCreate",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/configurations",
    validator: validate_AndroiddeviceprovisioningCustomersConfigurationsCreate_598235,
    base: "/", url: url_AndroiddeviceprovisioningCustomersConfigurationsCreate_598236,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersConfigurationsList_598215 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningCustomersConfigurationsList_598217(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningCustomersConfigurationsList_598216(
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
  var valid_598218 = path.getOrDefault("parent")
  valid_598218 = validateParameter(valid_598218, JString, required = true,
                                 default = nil)
  if valid_598218 != nil:
    section.add "parent", valid_598218
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
  var valid_598219 = query.getOrDefault("upload_protocol")
  valid_598219 = validateParameter(valid_598219, JString, required = false,
                                 default = nil)
  if valid_598219 != nil:
    section.add "upload_protocol", valid_598219
  var valid_598220 = query.getOrDefault("fields")
  valid_598220 = validateParameter(valid_598220, JString, required = false,
                                 default = nil)
  if valid_598220 != nil:
    section.add "fields", valid_598220
  var valid_598221 = query.getOrDefault("quotaUser")
  valid_598221 = validateParameter(valid_598221, JString, required = false,
                                 default = nil)
  if valid_598221 != nil:
    section.add "quotaUser", valid_598221
  var valid_598222 = query.getOrDefault("alt")
  valid_598222 = validateParameter(valid_598222, JString, required = false,
                                 default = newJString("json"))
  if valid_598222 != nil:
    section.add "alt", valid_598222
  var valid_598223 = query.getOrDefault("oauth_token")
  valid_598223 = validateParameter(valid_598223, JString, required = false,
                                 default = nil)
  if valid_598223 != nil:
    section.add "oauth_token", valid_598223
  var valid_598224 = query.getOrDefault("callback")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = nil)
  if valid_598224 != nil:
    section.add "callback", valid_598224
  var valid_598225 = query.getOrDefault("access_token")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = nil)
  if valid_598225 != nil:
    section.add "access_token", valid_598225
  var valid_598226 = query.getOrDefault("uploadType")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = nil)
  if valid_598226 != nil:
    section.add "uploadType", valid_598226
  var valid_598227 = query.getOrDefault("key")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = nil)
  if valid_598227 != nil:
    section.add "key", valid_598227
  var valid_598228 = query.getOrDefault("$.xgafv")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = newJString("1"))
  if valid_598228 != nil:
    section.add "$.xgafv", valid_598228
  var valid_598229 = query.getOrDefault("prettyPrint")
  valid_598229 = validateParameter(valid_598229, JBool, required = false,
                                 default = newJBool(true))
  if valid_598229 != nil:
    section.add "prettyPrint", valid_598229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598230: Call_AndroiddeviceprovisioningCustomersConfigurationsList_598215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a customer's configurations.
  ## 
  let valid = call_598230.validator(path, query, header, formData, body)
  let scheme = call_598230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598230.url(scheme.get, call_598230.host, call_598230.base,
                         call_598230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598230, url, valid)

proc call*(call_598231: Call_AndroiddeviceprovisioningCustomersConfigurationsList_598215;
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
  var path_598232 = newJObject()
  var query_598233 = newJObject()
  add(query_598233, "upload_protocol", newJString(uploadProtocol))
  add(query_598233, "fields", newJString(fields))
  add(query_598233, "quotaUser", newJString(quotaUser))
  add(query_598233, "alt", newJString(alt))
  add(query_598233, "oauth_token", newJString(oauthToken))
  add(query_598233, "callback", newJString(callback))
  add(query_598233, "access_token", newJString(accessToken))
  add(query_598233, "uploadType", newJString(uploadType))
  add(path_598232, "parent", newJString(parent))
  add(query_598233, "key", newJString(key))
  add(query_598233, "$.xgafv", newJString(Xgafv))
  add(query_598233, "prettyPrint", newJBool(prettyPrint))
  result = call_598231.call(path_598232, query_598233, nil, nil, nil)

var androiddeviceprovisioningCustomersConfigurationsList* = Call_AndroiddeviceprovisioningCustomersConfigurationsList_598215(
    name: "androiddeviceprovisioningCustomersConfigurationsList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/configurations",
    validator: validate_AndroiddeviceprovisioningCustomersConfigurationsList_598216,
    base: "/", url: url_AndroiddeviceprovisioningCustomersConfigurationsList_598217,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersCustomersCreate_598276 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningPartnersCustomersCreate_598278(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningPartnersCustomersCreate_598277(
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
  var valid_598279 = path.getOrDefault("parent")
  valid_598279 = validateParameter(valid_598279, JString, required = true,
                                 default = nil)
  if valid_598279 != nil:
    section.add "parent", valid_598279
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
  var valid_598280 = query.getOrDefault("upload_protocol")
  valid_598280 = validateParameter(valid_598280, JString, required = false,
                                 default = nil)
  if valid_598280 != nil:
    section.add "upload_protocol", valid_598280
  var valid_598281 = query.getOrDefault("fields")
  valid_598281 = validateParameter(valid_598281, JString, required = false,
                                 default = nil)
  if valid_598281 != nil:
    section.add "fields", valid_598281
  var valid_598282 = query.getOrDefault("quotaUser")
  valid_598282 = validateParameter(valid_598282, JString, required = false,
                                 default = nil)
  if valid_598282 != nil:
    section.add "quotaUser", valid_598282
  var valid_598283 = query.getOrDefault("alt")
  valid_598283 = validateParameter(valid_598283, JString, required = false,
                                 default = newJString("json"))
  if valid_598283 != nil:
    section.add "alt", valid_598283
  var valid_598284 = query.getOrDefault("oauth_token")
  valid_598284 = validateParameter(valid_598284, JString, required = false,
                                 default = nil)
  if valid_598284 != nil:
    section.add "oauth_token", valid_598284
  var valid_598285 = query.getOrDefault("callback")
  valid_598285 = validateParameter(valid_598285, JString, required = false,
                                 default = nil)
  if valid_598285 != nil:
    section.add "callback", valid_598285
  var valid_598286 = query.getOrDefault("access_token")
  valid_598286 = validateParameter(valid_598286, JString, required = false,
                                 default = nil)
  if valid_598286 != nil:
    section.add "access_token", valid_598286
  var valid_598287 = query.getOrDefault("uploadType")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = nil)
  if valid_598287 != nil:
    section.add "uploadType", valid_598287
  var valid_598288 = query.getOrDefault("key")
  valid_598288 = validateParameter(valid_598288, JString, required = false,
                                 default = nil)
  if valid_598288 != nil:
    section.add "key", valid_598288
  var valid_598289 = query.getOrDefault("$.xgafv")
  valid_598289 = validateParameter(valid_598289, JString, required = false,
                                 default = newJString("1"))
  if valid_598289 != nil:
    section.add "$.xgafv", valid_598289
  var valid_598290 = query.getOrDefault("prettyPrint")
  valid_598290 = validateParameter(valid_598290, JBool, required = false,
                                 default = newJBool(true))
  if valid_598290 != nil:
    section.add "prettyPrint", valid_598290
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

proc call*(call_598292: Call_AndroiddeviceprovisioningPartnersCustomersCreate_598276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a customer for zero-touch enrollment. After the method returns
  ## successfully, admin and owner roles can manage devices and EMM configs
  ## by calling API methods or using their zero-touch enrollment portal.
  ## The customer receives an email that welcomes them to zero-touch enrollment
  ## and explains how to sign into the portal.
  ## 
  let valid = call_598292.validator(path, query, header, formData, body)
  let scheme = call_598292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598292.url(scheme.get, call_598292.host, call_598292.base,
                         call_598292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598292, url, valid)

proc call*(call_598293: Call_AndroiddeviceprovisioningPartnersCustomersCreate_598276;
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
  var path_598294 = newJObject()
  var query_598295 = newJObject()
  var body_598296 = newJObject()
  add(query_598295, "upload_protocol", newJString(uploadProtocol))
  add(query_598295, "fields", newJString(fields))
  add(query_598295, "quotaUser", newJString(quotaUser))
  add(query_598295, "alt", newJString(alt))
  add(query_598295, "oauth_token", newJString(oauthToken))
  add(query_598295, "callback", newJString(callback))
  add(query_598295, "access_token", newJString(accessToken))
  add(query_598295, "uploadType", newJString(uploadType))
  add(path_598294, "parent", newJString(parent))
  add(query_598295, "key", newJString(key))
  add(query_598295, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598296 = body
  add(query_598295, "prettyPrint", newJBool(prettyPrint))
  result = call_598293.call(path_598294, query_598295, nil, nil, body_598296)

var androiddeviceprovisioningPartnersCustomersCreate* = Call_AndroiddeviceprovisioningPartnersCustomersCreate_598276(
    name: "androiddeviceprovisioningPartnersCustomersCreate",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/customers",
    validator: validate_AndroiddeviceprovisioningPartnersCustomersCreate_598277,
    base: "/", url: url_AndroiddeviceprovisioningPartnersCustomersCreate_598278,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersVendorsCustomersList_598255 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningPartnersVendorsCustomersList_598257(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningPartnersVendorsCustomersList_598256(
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
  var valid_598258 = path.getOrDefault("parent")
  valid_598258 = validateParameter(valid_598258, JString, required = true,
                                 default = nil)
  if valid_598258 != nil:
    section.add "parent", valid_598258
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
  var valid_598259 = query.getOrDefault("upload_protocol")
  valid_598259 = validateParameter(valid_598259, JString, required = false,
                                 default = nil)
  if valid_598259 != nil:
    section.add "upload_protocol", valid_598259
  var valid_598260 = query.getOrDefault("fields")
  valid_598260 = validateParameter(valid_598260, JString, required = false,
                                 default = nil)
  if valid_598260 != nil:
    section.add "fields", valid_598260
  var valid_598261 = query.getOrDefault("pageToken")
  valid_598261 = validateParameter(valid_598261, JString, required = false,
                                 default = nil)
  if valid_598261 != nil:
    section.add "pageToken", valid_598261
  var valid_598262 = query.getOrDefault("quotaUser")
  valid_598262 = validateParameter(valid_598262, JString, required = false,
                                 default = nil)
  if valid_598262 != nil:
    section.add "quotaUser", valid_598262
  var valid_598263 = query.getOrDefault("alt")
  valid_598263 = validateParameter(valid_598263, JString, required = false,
                                 default = newJString("json"))
  if valid_598263 != nil:
    section.add "alt", valid_598263
  var valid_598264 = query.getOrDefault("oauth_token")
  valid_598264 = validateParameter(valid_598264, JString, required = false,
                                 default = nil)
  if valid_598264 != nil:
    section.add "oauth_token", valid_598264
  var valid_598265 = query.getOrDefault("callback")
  valid_598265 = validateParameter(valid_598265, JString, required = false,
                                 default = nil)
  if valid_598265 != nil:
    section.add "callback", valid_598265
  var valid_598266 = query.getOrDefault("access_token")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = nil)
  if valid_598266 != nil:
    section.add "access_token", valid_598266
  var valid_598267 = query.getOrDefault("uploadType")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "uploadType", valid_598267
  var valid_598268 = query.getOrDefault("key")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = nil)
  if valid_598268 != nil:
    section.add "key", valid_598268
  var valid_598269 = query.getOrDefault("$.xgafv")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = newJString("1"))
  if valid_598269 != nil:
    section.add "$.xgafv", valid_598269
  var valid_598270 = query.getOrDefault("pageSize")
  valid_598270 = validateParameter(valid_598270, JInt, required = false, default = nil)
  if valid_598270 != nil:
    section.add "pageSize", valid_598270
  var valid_598271 = query.getOrDefault("prettyPrint")
  valid_598271 = validateParameter(valid_598271, JBool, required = false,
                                 default = newJBool(true))
  if valid_598271 != nil:
    section.add "prettyPrint", valid_598271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598272: Call_AndroiddeviceprovisioningPartnersVendorsCustomersList_598255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the customers of the vendor.
  ## 
  let valid = call_598272.validator(path, query, header, formData, body)
  let scheme = call_598272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598272.url(scheme.get, call_598272.host, call_598272.base,
                         call_598272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598272, url, valid)

proc call*(call_598273: Call_AndroiddeviceprovisioningPartnersVendorsCustomersList_598255;
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
  var path_598274 = newJObject()
  var query_598275 = newJObject()
  add(query_598275, "upload_protocol", newJString(uploadProtocol))
  add(query_598275, "fields", newJString(fields))
  add(query_598275, "pageToken", newJString(pageToken))
  add(query_598275, "quotaUser", newJString(quotaUser))
  add(query_598275, "alt", newJString(alt))
  add(query_598275, "oauth_token", newJString(oauthToken))
  add(query_598275, "callback", newJString(callback))
  add(query_598275, "access_token", newJString(accessToken))
  add(query_598275, "uploadType", newJString(uploadType))
  add(path_598274, "parent", newJString(parent))
  add(query_598275, "key", newJString(key))
  add(query_598275, "$.xgafv", newJString(Xgafv))
  add(query_598275, "pageSize", newJInt(pageSize))
  add(query_598275, "prettyPrint", newJBool(prettyPrint))
  result = call_598273.call(path_598274, query_598275, nil, nil, nil)

var androiddeviceprovisioningPartnersVendorsCustomersList* = Call_AndroiddeviceprovisioningPartnersVendorsCustomersList_598255(
    name: "androiddeviceprovisioningPartnersVendorsCustomersList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/customers",
    validator: validate_AndroiddeviceprovisioningPartnersVendorsCustomersList_598256,
    base: "/", url: url_AndroiddeviceprovisioningPartnersVendorsCustomersList_598257,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesList_598297 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningCustomersDevicesList_598299(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningCustomersDevicesList_598298(
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
  var valid_598300 = path.getOrDefault("parent")
  valid_598300 = validateParameter(valid_598300, JString, required = true,
                                 default = nil)
  if valid_598300 != nil:
    section.add "parent", valid_598300
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
  var valid_598301 = query.getOrDefault("upload_protocol")
  valid_598301 = validateParameter(valid_598301, JString, required = false,
                                 default = nil)
  if valid_598301 != nil:
    section.add "upload_protocol", valid_598301
  var valid_598302 = query.getOrDefault("fields")
  valid_598302 = validateParameter(valid_598302, JString, required = false,
                                 default = nil)
  if valid_598302 != nil:
    section.add "fields", valid_598302
  var valid_598303 = query.getOrDefault("pageToken")
  valid_598303 = validateParameter(valid_598303, JString, required = false,
                                 default = nil)
  if valid_598303 != nil:
    section.add "pageToken", valid_598303
  var valid_598304 = query.getOrDefault("quotaUser")
  valid_598304 = validateParameter(valid_598304, JString, required = false,
                                 default = nil)
  if valid_598304 != nil:
    section.add "quotaUser", valid_598304
  var valid_598305 = query.getOrDefault("alt")
  valid_598305 = validateParameter(valid_598305, JString, required = false,
                                 default = newJString("json"))
  if valid_598305 != nil:
    section.add "alt", valid_598305
  var valid_598306 = query.getOrDefault("oauth_token")
  valid_598306 = validateParameter(valid_598306, JString, required = false,
                                 default = nil)
  if valid_598306 != nil:
    section.add "oauth_token", valid_598306
  var valid_598307 = query.getOrDefault("callback")
  valid_598307 = validateParameter(valid_598307, JString, required = false,
                                 default = nil)
  if valid_598307 != nil:
    section.add "callback", valid_598307
  var valid_598308 = query.getOrDefault("access_token")
  valid_598308 = validateParameter(valid_598308, JString, required = false,
                                 default = nil)
  if valid_598308 != nil:
    section.add "access_token", valid_598308
  var valid_598309 = query.getOrDefault("uploadType")
  valid_598309 = validateParameter(valid_598309, JString, required = false,
                                 default = nil)
  if valid_598309 != nil:
    section.add "uploadType", valid_598309
  var valid_598310 = query.getOrDefault("key")
  valid_598310 = validateParameter(valid_598310, JString, required = false,
                                 default = nil)
  if valid_598310 != nil:
    section.add "key", valid_598310
  var valid_598311 = query.getOrDefault("$.xgafv")
  valid_598311 = validateParameter(valid_598311, JString, required = false,
                                 default = newJString("1"))
  if valid_598311 != nil:
    section.add "$.xgafv", valid_598311
  var valid_598312 = query.getOrDefault("pageSize")
  valid_598312 = validateParameter(valid_598312, JString, required = false,
                                 default = nil)
  if valid_598312 != nil:
    section.add "pageSize", valid_598312
  var valid_598313 = query.getOrDefault("prettyPrint")
  valid_598313 = validateParameter(valid_598313, JBool, required = false,
                                 default = newJBool(true))
  if valid_598313 != nil:
    section.add "prettyPrint", valid_598313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598314: Call_AndroiddeviceprovisioningCustomersDevicesList_598297;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a customer's devices.
  ## 
  let valid = call_598314.validator(path, query, header, formData, body)
  let scheme = call_598314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598314.url(scheme.get, call_598314.host, call_598314.base,
                         call_598314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598314, url, valid)

proc call*(call_598315: Call_AndroiddeviceprovisioningCustomersDevicesList_598297;
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
  var path_598316 = newJObject()
  var query_598317 = newJObject()
  add(query_598317, "upload_protocol", newJString(uploadProtocol))
  add(query_598317, "fields", newJString(fields))
  add(query_598317, "pageToken", newJString(pageToken))
  add(query_598317, "quotaUser", newJString(quotaUser))
  add(query_598317, "alt", newJString(alt))
  add(query_598317, "oauth_token", newJString(oauthToken))
  add(query_598317, "callback", newJString(callback))
  add(query_598317, "access_token", newJString(accessToken))
  add(query_598317, "uploadType", newJString(uploadType))
  add(path_598316, "parent", newJString(parent))
  add(query_598317, "key", newJString(key))
  add(query_598317, "$.xgafv", newJString(Xgafv))
  add(query_598317, "pageSize", newJString(pageSize))
  add(query_598317, "prettyPrint", newJBool(prettyPrint))
  result = call_598315.call(path_598316, query_598317, nil, nil, nil)

var androiddeviceprovisioningCustomersDevicesList* = Call_AndroiddeviceprovisioningCustomersDevicesList_598297(
    name: "androiddeviceprovisioningCustomersDevicesList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/devices",
    validator: validate_AndroiddeviceprovisioningCustomersDevicesList_598298,
    base: "/", url: url_AndroiddeviceprovisioningCustomersDevicesList_598299,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_598318 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_598320(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_598319(
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
  var valid_598321 = path.getOrDefault("parent")
  valid_598321 = validateParameter(valid_598321, JString, required = true,
                                 default = nil)
  if valid_598321 != nil:
    section.add "parent", valid_598321
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
  var valid_598322 = query.getOrDefault("upload_protocol")
  valid_598322 = validateParameter(valid_598322, JString, required = false,
                                 default = nil)
  if valid_598322 != nil:
    section.add "upload_protocol", valid_598322
  var valid_598323 = query.getOrDefault("fields")
  valid_598323 = validateParameter(valid_598323, JString, required = false,
                                 default = nil)
  if valid_598323 != nil:
    section.add "fields", valid_598323
  var valid_598324 = query.getOrDefault("quotaUser")
  valid_598324 = validateParameter(valid_598324, JString, required = false,
                                 default = nil)
  if valid_598324 != nil:
    section.add "quotaUser", valid_598324
  var valid_598325 = query.getOrDefault("alt")
  valid_598325 = validateParameter(valid_598325, JString, required = false,
                                 default = newJString("json"))
  if valid_598325 != nil:
    section.add "alt", valid_598325
  var valid_598326 = query.getOrDefault("oauth_token")
  valid_598326 = validateParameter(valid_598326, JString, required = false,
                                 default = nil)
  if valid_598326 != nil:
    section.add "oauth_token", valid_598326
  var valid_598327 = query.getOrDefault("callback")
  valid_598327 = validateParameter(valid_598327, JString, required = false,
                                 default = nil)
  if valid_598327 != nil:
    section.add "callback", valid_598327
  var valid_598328 = query.getOrDefault("access_token")
  valid_598328 = validateParameter(valid_598328, JString, required = false,
                                 default = nil)
  if valid_598328 != nil:
    section.add "access_token", valid_598328
  var valid_598329 = query.getOrDefault("uploadType")
  valid_598329 = validateParameter(valid_598329, JString, required = false,
                                 default = nil)
  if valid_598329 != nil:
    section.add "uploadType", valid_598329
  var valid_598330 = query.getOrDefault("key")
  valid_598330 = validateParameter(valid_598330, JString, required = false,
                                 default = nil)
  if valid_598330 != nil:
    section.add "key", valid_598330
  var valid_598331 = query.getOrDefault("$.xgafv")
  valid_598331 = validateParameter(valid_598331, JString, required = false,
                                 default = newJString("1"))
  if valid_598331 != nil:
    section.add "$.xgafv", valid_598331
  var valid_598332 = query.getOrDefault("prettyPrint")
  valid_598332 = validateParameter(valid_598332, JBool, required = false,
                                 default = newJBool(true))
  if valid_598332 != nil:
    section.add "prettyPrint", valid_598332
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

proc call*(call_598334: Call_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_598318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Applies a Configuration to the device to register the device for zero-touch
  ## enrollment. After applying a configuration to a device, the device
  ## automatically provisions itself on first boot, or next factory reset.
  ## 
  let valid = call_598334.validator(path, query, header, formData, body)
  let scheme = call_598334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598334.url(scheme.get, call_598334.host, call_598334.base,
                         call_598334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598334, url, valid)

proc call*(call_598335: Call_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_598318;
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
  var path_598336 = newJObject()
  var query_598337 = newJObject()
  var body_598338 = newJObject()
  add(query_598337, "upload_protocol", newJString(uploadProtocol))
  add(query_598337, "fields", newJString(fields))
  add(query_598337, "quotaUser", newJString(quotaUser))
  add(query_598337, "alt", newJString(alt))
  add(query_598337, "oauth_token", newJString(oauthToken))
  add(query_598337, "callback", newJString(callback))
  add(query_598337, "access_token", newJString(accessToken))
  add(query_598337, "uploadType", newJString(uploadType))
  add(path_598336, "parent", newJString(parent))
  add(query_598337, "key", newJString(key))
  add(query_598337, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598338 = body
  add(query_598337, "prettyPrint", newJBool(prettyPrint))
  result = call_598335.call(path_598336, query_598337, nil, nil, body_598338)

var androiddeviceprovisioningCustomersDevicesApplyConfiguration* = Call_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_598318(
    name: "androiddeviceprovisioningCustomersDevicesApplyConfiguration",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/devices:applyConfiguration", validator: validate_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_598319,
    base: "/",
    url: url_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_598320,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_598339 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_598341(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_598340(
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
  var valid_598342 = path.getOrDefault("parent")
  valid_598342 = validateParameter(valid_598342, JString, required = true,
                                 default = nil)
  if valid_598342 != nil:
    section.add "parent", valid_598342
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
  var valid_598343 = query.getOrDefault("upload_protocol")
  valid_598343 = validateParameter(valid_598343, JString, required = false,
                                 default = nil)
  if valid_598343 != nil:
    section.add "upload_protocol", valid_598343
  var valid_598344 = query.getOrDefault("fields")
  valid_598344 = validateParameter(valid_598344, JString, required = false,
                                 default = nil)
  if valid_598344 != nil:
    section.add "fields", valid_598344
  var valid_598345 = query.getOrDefault("quotaUser")
  valid_598345 = validateParameter(valid_598345, JString, required = false,
                                 default = nil)
  if valid_598345 != nil:
    section.add "quotaUser", valid_598345
  var valid_598346 = query.getOrDefault("alt")
  valid_598346 = validateParameter(valid_598346, JString, required = false,
                                 default = newJString("json"))
  if valid_598346 != nil:
    section.add "alt", valid_598346
  var valid_598347 = query.getOrDefault("oauth_token")
  valid_598347 = validateParameter(valid_598347, JString, required = false,
                                 default = nil)
  if valid_598347 != nil:
    section.add "oauth_token", valid_598347
  var valid_598348 = query.getOrDefault("callback")
  valid_598348 = validateParameter(valid_598348, JString, required = false,
                                 default = nil)
  if valid_598348 != nil:
    section.add "callback", valid_598348
  var valid_598349 = query.getOrDefault("access_token")
  valid_598349 = validateParameter(valid_598349, JString, required = false,
                                 default = nil)
  if valid_598349 != nil:
    section.add "access_token", valid_598349
  var valid_598350 = query.getOrDefault("uploadType")
  valid_598350 = validateParameter(valid_598350, JString, required = false,
                                 default = nil)
  if valid_598350 != nil:
    section.add "uploadType", valid_598350
  var valid_598351 = query.getOrDefault("key")
  valid_598351 = validateParameter(valid_598351, JString, required = false,
                                 default = nil)
  if valid_598351 != nil:
    section.add "key", valid_598351
  var valid_598352 = query.getOrDefault("$.xgafv")
  valid_598352 = validateParameter(valid_598352, JString, required = false,
                                 default = newJString("1"))
  if valid_598352 != nil:
    section.add "$.xgafv", valid_598352
  var valid_598353 = query.getOrDefault("prettyPrint")
  valid_598353 = validateParameter(valid_598353, JBool, required = false,
                                 default = newJBool(true))
  if valid_598353 != nil:
    section.add "prettyPrint", valid_598353
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

proc call*(call_598355: Call_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_598339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a configuration from device.
  ## 
  let valid = call_598355.validator(path, query, header, formData, body)
  let scheme = call_598355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598355.url(scheme.get, call_598355.host, call_598355.base,
                         call_598355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598355, url, valid)

proc call*(call_598356: Call_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_598339;
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
  var path_598357 = newJObject()
  var query_598358 = newJObject()
  var body_598359 = newJObject()
  add(query_598358, "upload_protocol", newJString(uploadProtocol))
  add(query_598358, "fields", newJString(fields))
  add(query_598358, "quotaUser", newJString(quotaUser))
  add(query_598358, "alt", newJString(alt))
  add(query_598358, "oauth_token", newJString(oauthToken))
  add(query_598358, "callback", newJString(callback))
  add(query_598358, "access_token", newJString(accessToken))
  add(query_598358, "uploadType", newJString(uploadType))
  add(path_598357, "parent", newJString(parent))
  add(query_598358, "key", newJString(key))
  add(query_598358, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598359 = body
  add(query_598358, "prettyPrint", newJBool(prettyPrint))
  result = call_598356.call(path_598357, query_598358, nil, nil, body_598359)

var androiddeviceprovisioningCustomersDevicesRemoveConfiguration* = Call_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_598339(
    name: "androiddeviceprovisioningCustomersDevicesRemoveConfiguration",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/devices:removeConfiguration", validator: validate_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_598340,
    base: "/",
    url: url_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_598341,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesUnclaim_598360 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningCustomersDevicesUnclaim_598362(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningCustomersDevicesUnclaim_598361(
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
  var valid_598363 = path.getOrDefault("parent")
  valid_598363 = validateParameter(valid_598363, JString, required = true,
                                 default = nil)
  if valid_598363 != nil:
    section.add "parent", valid_598363
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
  var valid_598364 = query.getOrDefault("upload_protocol")
  valid_598364 = validateParameter(valid_598364, JString, required = false,
                                 default = nil)
  if valid_598364 != nil:
    section.add "upload_protocol", valid_598364
  var valid_598365 = query.getOrDefault("fields")
  valid_598365 = validateParameter(valid_598365, JString, required = false,
                                 default = nil)
  if valid_598365 != nil:
    section.add "fields", valid_598365
  var valid_598366 = query.getOrDefault("quotaUser")
  valid_598366 = validateParameter(valid_598366, JString, required = false,
                                 default = nil)
  if valid_598366 != nil:
    section.add "quotaUser", valid_598366
  var valid_598367 = query.getOrDefault("alt")
  valid_598367 = validateParameter(valid_598367, JString, required = false,
                                 default = newJString("json"))
  if valid_598367 != nil:
    section.add "alt", valid_598367
  var valid_598368 = query.getOrDefault("oauth_token")
  valid_598368 = validateParameter(valid_598368, JString, required = false,
                                 default = nil)
  if valid_598368 != nil:
    section.add "oauth_token", valid_598368
  var valid_598369 = query.getOrDefault("callback")
  valid_598369 = validateParameter(valid_598369, JString, required = false,
                                 default = nil)
  if valid_598369 != nil:
    section.add "callback", valid_598369
  var valid_598370 = query.getOrDefault("access_token")
  valid_598370 = validateParameter(valid_598370, JString, required = false,
                                 default = nil)
  if valid_598370 != nil:
    section.add "access_token", valid_598370
  var valid_598371 = query.getOrDefault("uploadType")
  valid_598371 = validateParameter(valid_598371, JString, required = false,
                                 default = nil)
  if valid_598371 != nil:
    section.add "uploadType", valid_598371
  var valid_598372 = query.getOrDefault("key")
  valid_598372 = validateParameter(valid_598372, JString, required = false,
                                 default = nil)
  if valid_598372 != nil:
    section.add "key", valid_598372
  var valid_598373 = query.getOrDefault("$.xgafv")
  valid_598373 = validateParameter(valid_598373, JString, required = false,
                                 default = newJString("1"))
  if valid_598373 != nil:
    section.add "$.xgafv", valid_598373
  var valid_598374 = query.getOrDefault("prettyPrint")
  valid_598374 = validateParameter(valid_598374, JBool, required = false,
                                 default = newJBool(true))
  if valid_598374 != nil:
    section.add "prettyPrint", valid_598374
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

proc call*(call_598376: Call_AndroiddeviceprovisioningCustomersDevicesUnclaim_598360;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unclaims a device from a customer and removes it from zero-touch
  ## enrollment.
  ## 
  ## After removing a device, a customer must contact their reseller to register
  ## the device into zero-touch enrollment again.
  ## 
  let valid = call_598376.validator(path, query, header, formData, body)
  let scheme = call_598376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598376.url(scheme.get, call_598376.host, call_598376.base,
                         call_598376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598376, url, valid)

proc call*(call_598377: Call_AndroiddeviceprovisioningCustomersDevicesUnclaim_598360;
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
  var path_598378 = newJObject()
  var query_598379 = newJObject()
  var body_598380 = newJObject()
  add(query_598379, "upload_protocol", newJString(uploadProtocol))
  add(query_598379, "fields", newJString(fields))
  add(query_598379, "quotaUser", newJString(quotaUser))
  add(query_598379, "alt", newJString(alt))
  add(query_598379, "oauth_token", newJString(oauthToken))
  add(query_598379, "callback", newJString(callback))
  add(query_598379, "access_token", newJString(accessToken))
  add(query_598379, "uploadType", newJString(uploadType))
  add(path_598378, "parent", newJString(parent))
  add(query_598379, "key", newJString(key))
  add(query_598379, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598380 = body
  add(query_598379, "prettyPrint", newJBool(prettyPrint))
  result = call_598377.call(path_598378, query_598379, nil, nil, body_598380)

var androiddeviceprovisioningCustomersDevicesUnclaim* = Call_AndroiddeviceprovisioningCustomersDevicesUnclaim_598360(
    name: "androiddeviceprovisioningCustomersDevicesUnclaim",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/devices:unclaim",
    validator: validate_AndroiddeviceprovisioningCustomersDevicesUnclaim_598361,
    base: "/", url: url_AndroiddeviceprovisioningCustomersDevicesUnclaim_598362,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDpcsList_598381 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningCustomersDpcsList_598383(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningCustomersDpcsList_598382(path: JsonNode;
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
  var valid_598384 = path.getOrDefault("parent")
  valid_598384 = validateParameter(valid_598384, JString, required = true,
                                 default = nil)
  if valid_598384 != nil:
    section.add "parent", valid_598384
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
  var valid_598385 = query.getOrDefault("upload_protocol")
  valid_598385 = validateParameter(valid_598385, JString, required = false,
                                 default = nil)
  if valid_598385 != nil:
    section.add "upload_protocol", valid_598385
  var valid_598386 = query.getOrDefault("fields")
  valid_598386 = validateParameter(valid_598386, JString, required = false,
                                 default = nil)
  if valid_598386 != nil:
    section.add "fields", valid_598386
  var valid_598387 = query.getOrDefault("quotaUser")
  valid_598387 = validateParameter(valid_598387, JString, required = false,
                                 default = nil)
  if valid_598387 != nil:
    section.add "quotaUser", valid_598387
  var valid_598388 = query.getOrDefault("alt")
  valid_598388 = validateParameter(valid_598388, JString, required = false,
                                 default = newJString("json"))
  if valid_598388 != nil:
    section.add "alt", valid_598388
  var valid_598389 = query.getOrDefault("oauth_token")
  valid_598389 = validateParameter(valid_598389, JString, required = false,
                                 default = nil)
  if valid_598389 != nil:
    section.add "oauth_token", valid_598389
  var valid_598390 = query.getOrDefault("callback")
  valid_598390 = validateParameter(valid_598390, JString, required = false,
                                 default = nil)
  if valid_598390 != nil:
    section.add "callback", valid_598390
  var valid_598391 = query.getOrDefault("access_token")
  valid_598391 = validateParameter(valid_598391, JString, required = false,
                                 default = nil)
  if valid_598391 != nil:
    section.add "access_token", valid_598391
  var valid_598392 = query.getOrDefault("uploadType")
  valid_598392 = validateParameter(valid_598392, JString, required = false,
                                 default = nil)
  if valid_598392 != nil:
    section.add "uploadType", valid_598392
  var valid_598393 = query.getOrDefault("key")
  valid_598393 = validateParameter(valid_598393, JString, required = false,
                                 default = nil)
  if valid_598393 != nil:
    section.add "key", valid_598393
  var valid_598394 = query.getOrDefault("$.xgafv")
  valid_598394 = validateParameter(valid_598394, JString, required = false,
                                 default = newJString("1"))
  if valid_598394 != nil:
    section.add "$.xgafv", valid_598394
  var valid_598395 = query.getOrDefault("prettyPrint")
  valid_598395 = validateParameter(valid_598395, JBool, required = false,
                                 default = newJBool(true))
  if valid_598395 != nil:
    section.add "prettyPrint", valid_598395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598396: Call_AndroiddeviceprovisioningCustomersDpcsList_598381;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the DPCs (device policy controllers) that support zero-touch
  ## enrollment.
  ## 
  let valid = call_598396.validator(path, query, header, formData, body)
  let scheme = call_598396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598396.url(scheme.get, call_598396.host, call_598396.base,
                         call_598396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598396, url, valid)

proc call*(call_598397: Call_AndroiddeviceprovisioningCustomersDpcsList_598381;
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
  var path_598398 = newJObject()
  var query_598399 = newJObject()
  add(query_598399, "upload_protocol", newJString(uploadProtocol))
  add(query_598399, "fields", newJString(fields))
  add(query_598399, "quotaUser", newJString(quotaUser))
  add(query_598399, "alt", newJString(alt))
  add(query_598399, "oauth_token", newJString(oauthToken))
  add(query_598399, "callback", newJString(callback))
  add(query_598399, "access_token", newJString(accessToken))
  add(query_598399, "uploadType", newJString(uploadType))
  add(path_598398, "parent", newJString(parent))
  add(query_598399, "key", newJString(key))
  add(query_598399, "$.xgafv", newJString(Xgafv))
  add(query_598399, "prettyPrint", newJBool(prettyPrint))
  result = call_598397.call(path_598398, query_598399, nil, nil, nil)

var androiddeviceprovisioningCustomersDpcsList* = Call_AndroiddeviceprovisioningCustomersDpcsList_598381(
    name: "androiddeviceprovisioningCustomersDpcsList", meth: HttpMethod.HttpGet,
    host: "androiddeviceprovisioning.googleapis.com", route: "/v1/{parent}/dpcs",
    validator: validate_AndroiddeviceprovisioningCustomersDpcsList_598382,
    base: "/", url: url_AndroiddeviceprovisioningCustomersDpcsList_598383,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersVendorsList_598400 = ref object of OpenApiRestCall_597408
proc url_AndroiddeviceprovisioningPartnersVendorsList_598402(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AndroiddeviceprovisioningPartnersVendorsList_598401(path: JsonNode;
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
  var valid_598403 = path.getOrDefault("parent")
  valid_598403 = validateParameter(valid_598403, JString, required = true,
                                 default = nil)
  if valid_598403 != nil:
    section.add "parent", valid_598403
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
  var valid_598404 = query.getOrDefault("upload_protocol")
  valid_598404 = validateParameter(valid_598404, JString, required = false,
                                 default = nil)
  if valid_598404 != nil:
    section.add "upload_protocol", valid_598404
  var valid_598405 = query.getOrDefault("fields")
  valid_598405 = validateParameter(valid_598405, JString, required = false,
                                 default = nil)
  if valid_598405 != nil:
    section.add "fields", valid_598405
  var valid_598406 = query.getOrDefault("pageToken")
  valid_598406 = validateParameter(valid_598406, JString, required = false,
                                 default = nil)
  if valid_598406 != nil:
    section.add "pageToken", valid_598406
  var valid_598407 = query.getOrDefault("quotaUser")
  valid_598407 = validateParameter(valid_598407, JString, required = false,
                                 default = nil)
  if valid_598407 != nil:
    section.add "quotaUser", valid_598407
  var valid_598408 = query.getOrDefault("alt")
  valid_598408 = validateParameter(valid_598408, JString, required = false,
                                 default = newJString("json"))
  if valid_598408 != nil:
    section.add "alt", valid_598408
  var valid_598409 = query.getOrDefault("oauth_token")
  valid_598409 = validateParameter(valid_598409, JString, required = false,
                                 default = nil)
  if valid_598409 != nil:
    section.add "oauth_token", valid_598409
  var valid_598410 = query.getOrDefault("callback")
  valid_598410 = validateParameter(valid_598410, JString, required = false,
                                 default = nil)
  if valid_598410 != nil:
    section.add "callback", valid_598410
  var valid_598411 = query.getOrDefault("access_token")
  valid_598411 = validateParameter(valid_598411, JString, required = false,
                                 default = nil)
  if valid_598411 != nil:
    section.add "access_token", valid_598411
  var valid_598412 = query.getOrDefault("uploadType")
  valid_598412 = validateParameter(valid_598412, JString, required = false,
                                 default = nil)
  if valid_598412 != nil:
    section.add "uploadType", valid_598412
  var valid_598413 = query.getOrDefault("key")
  valid_598413 = validateParameter(valid_598413, JString, required = false,
                                 default = nil)
  if valid_598413 != nil:
    section.add "key", valid_598413
  var valid_598414 = query.getOrDefault("$.xgafv")
  valid_598414 = validateParameter(valid_598414, JString, required = false,
                                 default = newJString("1"))
  if valid_598414 != nil:
    section.add "$.xgafv", valid_598414
  var valid_598415 = query.getOrDefault("pageSize")
  valid_598415 = validateParameter(valid_598415, JInt, required = false, default = nil)
  if valid_598415 != nil:
    section.add "pageSize", valid_598415
  var valid_598416 = query.getOrDefault("prettyPrint")
  valid_598416 = validateParameter(valid_598416, JBool, required = false,
                                 default = newJBool(true))
  if valid_598416 != nil:
    section.add "prettyPrint", valid_598416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598417: Call_AndroiddeviceprovisioningPartnersVendorsList_598400;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the vendors of the partner.
  ## 
  let valid = call_598417.validator(path, query, header, formData, body)
  let scheme = call_598417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598417.url(scheme.get, call_598417.host, call_598417.base,
                         call_598417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598417, url, valid)

proc call*(call_598418: Call_AndroiddeviceprovisioningPartnersVendorsList_598400;
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
  var path_598419 = newJObject()
  var query_598420 = newJObject()
  add(query_598420, "upload_protocol", newJString(uploadProtocol))
  add(query_598420, "fields", newJString(fields))
  add(query_598420, "pageToken", newJString(pageToken))
  add(query_598420, "quotaUser", newJString(quotaUser))
  add(query_598420, "alt", newJString(alt))
  add(query_598420, "oauth_token", newJString(oauthToken))
  add(query_598420, "callback", newJString(callback))
  add(query_598420, "access_token", newJString(accessToken))
  add(query_598420, "uploadType", newJString(uploadType))
  add(path_598419, "parent", newJString(parent))
  add(query_598420, "key", newJString(key))
  add(query_598420, "$.xgafv", newJString(Xgafv))
  add(query_598420, "pageSize", newJInt(pageSize))
  add(query_598420, "prettyPrint", newJBool(prettyPrint))
  result = call_598418.call(path_598419, query_598420, nil, nil, nil)

var androiddeviceprovisioningPartnersVendorsList* = Call_AndroiddeviceprovisioningPartnersVendorsList_598400(
    name: "androiddeviceprovisioningPartnersVendorsList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/vendors",
    validator: validate_AndroiddeviceprovisioningPartnersVendorsList_598401,
    base: "/", url: url_AndroiddeviceprovisioningPartnersVendorsList_598402,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
