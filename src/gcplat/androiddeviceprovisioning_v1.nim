
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579364): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "androiddeviceprovisioning"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroiddeviceprovisioningCustomersList_579635 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningCustomersList_579637(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_AndroiddeviceprovisioningCustomersList_579636(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the user's customer accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of customers to show in a page of results.
  ## A number between 1 and 100 (inclusive).
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token specifying which result page to return.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579749 = query.getOrDefault("key")
  valid_579749 = validateParameter(valid_579749, JString, required = false,
                                 default = nil)
  if valid_579749 != nil:
    section.add "key", valid_579749
  var valid_579763 = query.getOrDefault("prettyPrint")
  valid_579763 = validateParameter(valid_579763, JBool, required = false,
                                 default = newJBool(true))
  if valid_579763 != nil:
    section.add "prettyPrint", valid_579763
  var valid_579764 = query.getOrDefault("oauth_token")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "oauth_token", valid_579764
  var valid_579765 = query.getOrDefault("$.xgafv")
  valid_579765 = validateParameter(valid_579765, JString, required = false,
                                 default = newJString("1"))
  if valid_579765 != nil:
    section.add "$.xgafv", valid_579765
  var valid_579766 = query.getOrDefault("pageSize")
  valid_579766 = validateParameter(valid_579766, JInt, required = false, default = nil)
  if valid_579766 != nil:
    section.add "pageSize", valid_579766
  var valid_579767 = query.getOrDefault("alt")
  valid_579767 = validateParameter(valid_579767, JString, required = false,
                                 default = newJString("json"))
  if valid_579767 != nil:
    section.add "alt", valid_579767
  var valid_579768 = query.getOrDefault("uploadType")
  valid_579768 = validateParameter(valid_579768, JString, required = false,
                                 default = nil)
  if valid_579768 != nil:
    section.add "uploadType", valid_579768
  var valid_579769 = query.getOrDefault("quotaUser")
  valid_579769 = validateParameter(valid_579769, JString, required = false,
                                 default = nil)
  if valid_579769 != nil:
    section.add "quotaUser", valid_579769
  var valid_579770 = query.getOrDefault("pageToken")
  valid_579770 = validateParameter(valid_579770, JString, required = false,
                                 default = nil)
  if valid_579770 != nil:
    section.add "pageToken", valid_579770
  var valid_579771 = query.getOrDefault("callback")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = nil)
  if valid_579771 != nil:
    section.add "callback", valid_579771
  var valid_579772 = query.getOrDefault("fields")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = nil)
  if valid_579772 != nil:
    section.add "fields", valid_579772
  var valid_579773 = query.getOrDefault("access_token")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "access_token", valid_579773
  var valid_579774 = query.getOrDefault("upload_protocol")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = nil)
  if valid_579774 != nil:
    section.add "upload_protocol", valid_579774
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579797: Call_AndroiddeviceprovisioningCustomersList_579635;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the user's customer accounts.
  ## 
  let valid = call_579797.validator(path, query, header, formData, body)
  let scheme = call_579797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579797.url(scheme.get, call_579797.host, call_579797.base,
                         call_579797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579797, url, valid)

proc call*(call_579868: Call_AndroiddeviceprovisioningCustomersList_579635;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningCustomersList
  ## Lists the user's customer accounts.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of customers to show in a page of results.
  ## A number between 1 and 100 (inclusive).
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token specifying which result page to return.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579869 = newJObject()
  add(query_579869, "key", newJString(key))
  add(query_579869, "prettyPrint", newJBool(prettyPrint))
  add(query_579869, "oauth_token", newJString(oauthToken))
  add(query_579869, "$.xgafv", newJString(Xgafv))
  add(query_579869, "pageSize", newJInt(pageSize))
  add(query_579869, "alt", newJString(alt))
  add(query_579869, "uploadType", newJString(uploadType))
  add(query_579869, "quotaUser", newJString(quotaUser))
  add(query_579869, "pageToken", newJString(pageToken))
  add(query_579869, "callback", newJString(callback))
  add(query_579869, "fields", newJString(fields))
  add(query_579869, "access_token", newJString(accessToken))
  add(query_579869, "upload_protocol", newJString(uploadProtocol))
  result = call_579868.call(nil, query_579869, nil, nil, nil)

var androiddeviceprovisioningCustomersList* = Call_AndroiddeviceprovisioningCustomersList_579635(
    name: "androiddeviceprovisioningCustomersList", meth: HttpMethod.HttpGet,
    host: "androiddeviceprovisioning.googleapis.com", route: "/v1/customers",
    validator: validate_AndroiddeviceprovisioningCustomersList_579636, base: "/",
    url: url_AndroiddeviceprovisioningCustomersList_579637,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesMetadata_579909 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningPartnersDevicesMetadata_579911(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesMetadata_579910(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates reseller metadata associated with the device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   metadataOwnerId: JString (required)
  ##                  : Required. The owner of the newly set metadata. Set this to the partner ID.
  ##   deviceId: JString (required)
  ##           : Required. The ID of the device.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `metadataOwnerId` field"
  var valid_579926 = path.getOrDefault("metadataOwnerId")
  valid_579926 = validateParameter(valid_579926, JString, required = true,
                                 default = nil)
  if valid_579926 != nil:
    section.add "metadataOwnerId", valid_579926
  var valid_579927 = path.getOrDefault("deviceId")
  valid_579927 = validateParameter(valid_579927, JString, required = true,
                                 default = nil)
  if valid_579927 != nil:
    section.add "deviceId", valid_579927
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579928 = query.getOrDefault("key")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = nil)
  if valid_579928 != nil:
    section.add "key", valid_579928
  var valid_579929 = query.getOrDefault("prettyPrint")
  valid_579929 = validateParameter(valid_579929, JBool, required = false,
                                 default = newJBool(true))
  if valid_579929 != nil:
    section.add "prettyPrint", valid_579929
  var valid_579930 = query.getOrDefault("oauth_token")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "oauth_token", valid_579930
  var valid_579931 = query.getOrDefault("$.xgafv")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = newJString("1"))
  if valid_579931 != nil:
    section.add "$.xgafv", valid_579931
  var valid_579932 = query.getOrDefault("alt")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = newJString("json"))
  if valid_579932 != nil:
    section.add "alt", valid_579932
  var valid_579933 = query.getOrDefault("uploadType")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "uploadType", valid_579933
  var valid_579934 = query.getOrDefault("quotaUser")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "quotaUser", valid_579934
  var valid_579935 = query.getOrDefault("callback")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "callback", valid_579935
  var valid_579936 = query.getOrDefault("fields")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "fields", valid_579936
  var valid_579937 = query.getOrDefault("access_token")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "access_token", valid_579937
  var valid_579938 = query.getOrDefault("upload_protocol")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "upload_protocol", valid_579938
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

proc call*(call_579940: Call_AndroiddeviceprovisioningPartnersDevicesMetadata_579909;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates reseller metadata associated with the device.
  ## 
  let valid = call_579940.validator(path, query, header, formData, body)
  let scheme = call_579940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579940.url(scheme.get, call_579940.host, call_579940.base,
                         call_579940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579940, url, valid)

proc call*(call_579941: Call_AndroiddeviceprovisioningPartnersDevicesMetadata_579909;
          metadataOwnerId: string; deviceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningPartnersDevicesMetadata
  ## Updates reseller metadata associated with the device.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   metadataOwnerId: string (required)
  ##                  : Required. The owner of the newly set metadata. Set this to the partner ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   deviceId: string (required)
  ##           : Required. The ID of the device.
  var path_579942 = newJObject()
  var query_579943 = newJObject()
  var body_579944 = newJObject()
  add(query_579943, "key", newJString(key))
  add(query_579943, "prettyPrint", newJBool(prettyPrint))
  add(query_579943, "oauth_token", newJString(oauthToken))
  add(query_579943, "$.xgafv", newJString(Xgafv))
  add(query_579943, "alt", newJString(alt))
  add(query_579943, "uploadType", newJString(uploadType))
  add(query_579943, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579944 = body
  add(query_579943, "callback", newJString(callback))
  add(path_579942, "metadataOwnerId", newJString(metadataOwnerId))
  add(query_579943, "fields", newJString(fields))
  add(query_579943, "access_token", newJString(accessToken))
  add(query_579943, "upload_protocol", newJString(uploadProtocol))
  add(path_579942, "deviceId", newJString(deviceId))
  result = call_579941.call(path_579942, query_579943, nil, nil, body_579944)

var androiddeviceprovisioningPartnersDevicesMetadata* = Call_AndroiddeviceprovisioningPartnersDevicesMetadata_579909(
    name: "androiddeviceprovisioningPartnersDevicesMetadata",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{metadataOwnerId}/devices/{deviceId}/metadata",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesMetadata_579910,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesMetadata_579911,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersCustomersList_579945 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningPartnersCustomersList_579947(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersCustomersList_579946(
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
  var valid_579948 = path.getOrDefault("partnerId")
  valid_579948 = validateParameter(valid_579948, JString, required = true,
                                 default = nil)
  if valid_579948 != nil:
    section.add "partnerId", valid_579948
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of results to be returned. If not specified or 0, all
  ## the records are returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results returned by the server.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579949 = query.getOrDefault("key")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "key", valid_579949
  var valid_579950 = query.getOrDefault("prettyPrint")
  valid_579950 = validateParameter(valid_579950, JBool, required = false,
                                 default = newJBool(true))
  if valid_579950 != nil:
    section.add "prettyPrint", valid_579950
  var valid_579951 = query.getOrDefault("oauth_token")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "oauth_token", valid_579951
  var valid_579952 = query.getOrDefault("$.xgafv")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = newJString("1"))
  if valid_579952 != nil:
    section.add "$.xgafv", valid_579952
  var valid_579953 = query.getOrDefault("pageSize")
  valid_579953 = validateParameter(valid_579953, JInt, required = false, default = nil)
  if valid_579953 != nil:
    section.add "pageSize", valid_579953
  var valid_579954 = query.getOrDefault("alt")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = newJString("json"))
  if valid_579954 != nil:
    section.add "alt", valid_579954
  var valid_579955 = query.getOrDefault("uploadType")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "uploadType", valid_579955
  var valid_579956 = query.getOrDefault("quotaUser")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "quotaUser", valid_579956
  var valid_579957 = query.getOrDefault("pageToken")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "pageToken", valid_579957
  var valid_579958 = query.getOrDefault("callback")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "callback", valid_579958
  var valid_579959 = query.getOrDefault("fields")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "fields", valid_579959
  var valid_579960 = query.getOrDefault("access_token")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "access_token", valid_579960
  var valid_579961 = query.getOrDefault("upload_protocol")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "upload_protocol", valid_579961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579962: Call_AndroiddeviceprovisioningPartnersCustomersList_579945;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the customers that are enrolled to the reseller identified by the
  ## `partnerId` argument. This list includes customers that the reseller
  ## created and customers that enrolled themselves using the portal.
  ## 
  let valid = call_579962.validator(path, query, header, formData, body)
  let scheme = call_579962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579962.url(scheme.get, call_579962.host, call_579962.base,
                         call_579962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579962, url, valid)

proc call*(call_579963: Call_AndroiddeviceprovisioningPartnersCustomersList_579945;
          partnerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningPartnersCustomersList
  ## Lists the customers that are enrolled to the reseller identified by the
  ## `partnerId` argument. This list includes customers that the reseller
  ## created and customers that enrolled themselves using the portal.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   partnerId: string (required)
  ##            : Required. The ID of the reseller partner.
  ##   pageSize: int
  ##           : The maximum number of results to be returned. If not specified or 0, all
  ## the records are returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results returned by the server.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579964 = newJObject()
  var query_579965 = newJObject()
  add(query_579965, "key", newJString(key))
  add(query_579965, "prettyPrint", newJBool(prettyPrint))
  add(query_579965, "oauth_token", newJString(oauthToken))
  add(query_579965, "$.xgafv", newJString(Xgafv))
  add(path_579964, "partnerId", newJString(partnerId))
  add(query_579965, "pageSize", newJInt(pageSize))
  add(query_579965, "alt", newJString(alt))
  add(query_579965, "uploadType", newJString(uploadType))
  add(query_579965, "quotaUser", newJString(quotaUser))
  add(query_579965, "pageToken", newJString(pageToken))
  add(query_579965, "callback", newJString(callback))
  add(query_579965, "fields", newJString(fields))
  add(query_579965, "access_token", newJString(accessToken))
  add(query_579965, "upload_protocol", newJString(uploadProtocol))
  result = call_579963.call(path_579964, query_579965, nil, nil, nil)

var androiddeviceprovisioningPartnersCustomersList* = Call_AndroiddeviceprovisioningPartnersCustomersList_579945(
    name: "androiddeviceprovisioningPartnersCustomersList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/customers",
    validator: validate_AndroiddeviceprovisioningPartnersCustomersList_579946,
    base: "/", url: url_AndroiddeviceprovisioningPartnersCustomersList_579947,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesClaim_579966 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningPartnersDevicesClaim_579968(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesClaim_579967(
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
  var valid_579969 = path.getOrDefault("partnerId")
  valid_579969 = validateParameter(valid_579969, JString, required = true,
                                 default = nil)
  if valid_579969 != nil:
    section.add "partnerId", valid_579969
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579970 = query.getOrDefault("key")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "key", valid_579970
  var valid_579971 = query.getOrDefault("prettyPrint")
  valid_579971 = validateParameter(valid_579971, JBool, required = false,
                                 default = newJBool(true))
  if valid_579971 != nil:
    section.add "prettyPrint", valid_579971
  var valid_579972 = query.getOrDefault("oauth_token")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "oauth_token", valid_579972
  var valid_579973 = query.getOrDefault("$.xgafv")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = newJString("1"))
  if valid_579973 != nil:
    section.add "$.xgafv", valid_579973
  var valid_579974 = query.getOrDefault("alt")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = newJString("json"))
  if valid_579974 != nil:
    section.add "alt", valid_579974
  var valid_579975 = query.getOrDefault("uploadType")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "uploadType", valid_579975
  var valid_579976 = query.getOrDefault("quotaUser")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "quotaUser", valid_579976
  var valid_579977 = query.getOrDefault("callback")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "callback", valid_579977
  var valid_579978 = query.getOrDefault("fields")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "fields", valid_579978
  var valid_579979 = query.getOrDefault("access_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "access_token", valid_579979
  var valid_579980 = query.getOrDefault("upload_protocol")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "upload_protocol", valid_579980
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

proc call*(call_579982: Call_AndroiddeviceprovisioningPartnersDevicesClaim_579966;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Claims a device for a customer and adds it to zero-touch enrollment. If the
  ## device is already claimed by another customer, the call returns an error.
  ## 
  let valid = call_579982.validator(path, query, header, formData, body)
  let scheme = call_579982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579982.url(scheme.get, call_579982.host, call_579982.base,
                         call_579982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579982, url, valid)

proc call*(call_579983: Call_AndroiddeviceprovisioningPartnersDevicesClaim_579966;
          partnerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningPartnersDevicesClaim
  ## Claims a device for a customer and adds it to zero-touch enrollment. If the
  ## device is already claimed by another customer, the call returns an error.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   partnerId: string (required)
  ##            : Required. The ID of the reseller partner.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579984 = newJObject()
  var query_579985 = newJObject()
  var body_579986 = newJObject()
  add(query_579985, "key", newJString(key))
  add(query_579985, "prettyPrint", newJBool(prettyPrint))
  add(query_579985, "oauth_token", newJString(oauthToken))
  add(query_579985, "$.xgafv", newJString(Xgafv))
  add(path_579984, "partnerId", newJString(partnerId))
  add(query_579985, "alt", newJString(alt))
  add(query_579985, "uploadType", newJString(uploadType))
  add(query_579985, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579986 = body
  add(query_579985, "callback", newJString(callback))
  add(query_579985, "fields", newJString(fields))
  add(query_579985, "access_token", newJString(accessToken))
  add(query_579985, "upload_protocol", newJString(uploadProtocol))
  result = call_579983.call(path_579984, query_579985, nil, nil, body_579986)

var androiddeviceprovisioningPartnersDevicesClaim* = Call_AndroiddeviceprovisioningPartnersDevicesClaim_579966(
    name: "androiddeviceprovisioningPartnersDevicesClaim",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:claim",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesClaim_579967,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesClaim_579968,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesClaimAsync_579987 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningPartnersDevicesClaimAsync_579989(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesClaimAsync_579988(
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
  var valid_579990 = path.getOrDefault("partnerId")
  valid_579990 = validateParameter(valid_579990, JString, required = true,
                                 default = nil)
  if valid_579990 != nil:
    section.add "partnerId", valid_579990
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579991 = query.getOrDefault("key")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "key", valid_579991
  var valid_579992 = query.getOrDefault("prettyPrint")
  valid_579992 = validateParameter(valid_579992, JBool, required = false,
                                 default = newJBool(true))
  if valid_579992 != nil:
    section.add "prettyPrint", valid_579992
  var valid_579993 = query.getOrDefault("oauth_token")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "oauth_token", valid_579993
  var valid_579994 = query.getOrDefault("$.xgafv")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("1"))
  if valid_579994 != nil:
    section.add "$.xgafv", valid_579994
  var valid_579995 = query.getOrDefault("alt")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = newJString("json"))
  if valid_579995 != nil:
    section.add "alt", valid_579995
  var valid_579996 = query.getOrDefault("uploadType")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "uploadType", valid_579996
  var valid_579997 = query.getOrDefault("quotaUser")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "quotaUser", valid_579997
  var valid_579998 = query.getOrDefault("callback")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "callback", valid_579998
  var valid_579999 = query.getOrDefault("fields")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "fields", valid_579999
  var valid_580000 = query.getOrDefault("access_token")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "access_token", valid_580000
  var valid_580001 = query.getOrDefault("upload_protocol")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "upload_protocol", valid_580001
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

proc call*(call_580003: Call_AndroiddeviceprovisioningPartnersDevicesClaimAsync_579987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Claims a batch of devices for a customer asynchronously. Adds the devices
  ## to zero-touch enrollment. To learn more, read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ## 
  let valid = call_580003.validator(path, query, header, formData, body)
  let scheme = call_580003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580003.url(scheme.get, call_580003.host, call_580003.base,
                         call_580003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580003, url, valid)

proc call*(call_580004: Call_AndroiddeviceprovisioningPartnersDevicesClaimAsync_579987;
          partnerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningPartnersDevicesClaimAsync
  ## Claims a batch of devices for a customer asynchronously. Adds the devices
  ## to zero-touch enrollment. To learn more, read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   partnerId: string (required)
  ##            : Required. The ID of the reseller partner.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580005 = newJObject()
  var query_580006 = newJObject()
  var body_580007 = newJObject()
  add(query_580006, "key", newJString(key))
  add(query_580006, "prettyPrint", newJBool(prettyPrint))
  add(query_580006, "oauth_token", newJString(oauthToken))
  add(query_580006, "$.xgafv", newJString(Xgafv))
  add(path_580005, "partnerId", newJString(partnerId))
  add(query_580006, "alt", newJString(alt))
  add(query_580006, "uploadType", newJString(uploadType))
  add(query_580006, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580007 = body
  add(query_580006, "callback", newJString(callback))
  add(query_580006, "fields", newJString(fields))
  add(query_580006, "access_token", newJString(accessToken))
  add(query_580006, "upload_protocol", newJString(uploadProtocol))
  result = call_580004.call(path_580005, query_580006, nil, nil, body_580007)

var androiddeviceprovisioningPartnersDevicesClaimAsync* = Call_AndroiddeviceprovisioningPartnersDevicesClaimAsync_579987(
    name: "androiddeviceprovisioningPartnersDevicesClaimAsync",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:claimAsync",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesClaimAsync_579988,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesClaimAsync_579989,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_580008 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_580010(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_580009(
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
  var valid_580011 = path.getOrDefault("partnerId")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "partnerId", valid_580011
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580012 = query.getOrDefault("key")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "key", valid_580012
  var valid_580013 = query.getOrDefault("prettyPrint")
  valid_580013 = validateParameter(valid_580013, JBool, required = false,
                                 default = newJBool(true))
  if valid_580013 != nil:
    section.add "prettyPrint", valid_580013
  var valid_580014 = query.getOrDefault("oauth_token")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "oauth_token", valid_580014
  var valid_580015 = query.getOrDefault("$.xgafv")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("1"))
  if valid_580015 != nil:
    section.add "$.xgafv", valid_580015
  var valid_580016 = query.getOrDefault("alt")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = newJString("json"))
  if valid_580016 != nil:
    section.add "alt", valid_580016
  var valid_580017 = query.getOrDefault("uploadType")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "uploadType", valid_580017
  var valid_580018 = query.getOrDefault("quotaUser")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "quotaUser", valid_580018
  var valid_580019 = query.getOrDefault("callback")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "callback", valid_580019
  var valid_580020 = query.getOrDefault("fields")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "fields", valid_580020
  var valid_580021 = query.getOrDefault("access_token")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "access_token", valid_580021
  var valid_580022 = query.getOrDefault("upload_protocol")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "upload_protocol", valid_580022
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

proc call*(call_580024: Call_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_580008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Finds devices by hardware identifiers, such as IMEI.
  ## 
  let valid = call_580024.validator(path, query, header, formData, body)
  let scheme = call_580024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580024.url(scheme.get, call_580024.host, call_580024.base,
                         call_580024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580024, url, valid)

proc call*(call_580025: Call_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_580008;
          partnerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningPartnersDevicesFindByIdentifier
  ## Finds devices by hardware identifiers, such as IMEI.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   partnerId: string (required)
  ##            : Required. The ID of the reseller partner.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580026 = newJObject()
  var query_580027 = newJObject()
  var body_580028 = newJObject()
  add(query_580027, "key", newJString(key))
  add(query_580027, "prettyPrint", newJBool(prettyPrint))
  add(query_580027, "oauth_token", newJString(oauthToken))
  add(query_580027, "$.xgafv", newJString(Xgafv))
  add(path_580026, "partnerId", newJString(partnerId))
  add(query_580027, "alt", newJString(alt))
  add(query_580027, "uploadType", newJString(uploadType))
  add(query_580027, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580028 = body
  add(query_580027, "callback", newJString(callback))
  add(query_580027, "fields", newJString(fields))
  add(query_580027, "access_token", newJString(accessToken))
  add(query_580027, "upload_protocol", newJString(uploadProtocol))
  result = call_580025.call(path_580026, query_580027, nil, nil, body_580028)

var androiddeviceprovisioningPartnersDevicesFindByIdentifier* = Call_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_580008(
    name: "androiddeviceprovisioningPartnersDevicesFindByIdentifier",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:findByIdentifier", validator: validate_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_580009,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_580010,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesFindByOwner_580029 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningPartnersDevicesFindByOwner_580031(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesFindByOwner_580030(
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
  var valid_580032 = path.getOrDefault("partnerId")
  valid_580032 = validateParameter(valid_580032, JString, required = true,
                                 default = nil)
  if valid_580032 != nil:
    section.add "partnerId", valid_580032
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580033 = query.getOrDefault("key")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "key", valid_580033
  var valid_580034 = query.getOrDefault("prettyPrint")
  valid_580034 = validateParameter(valid_580034, JBool, required = false,
                                 default = newJBool(true))
  if valid_580034 != nil:
    section.add "prettyPrint", valid_580034
  var valid_580035 = query.getOrDefault("oauth_token")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "oauth_token", valid_580035
  var valid_580036 = query.getOrDefault("$.xgafv")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("1"))
  if valid_580036 != nil:
    section.add "$.xgafv", valid_580036
  var valid_580037 = query.getOrDefault("alt")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = newJString("json"))
  if valid_580037 != nil:
    section.add "alt", valid_580037
  var valid_580038 = query.getOrDefault("uploadType")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "uploadType", valid_580038
  var valid_580039 = query.getOrDefault("quotaUser")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "quotaUser", valid_580039
  var valid_580040 = query.getOrDefault("callback")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "callback", valid_580040
  var valid_580041 = query.getOrDefault("fields")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "fields", valid_580041
  var valid_580042 = query.getOrDefault("access_token")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "access_token", valid_580042
  var valid_580043 = query.getOrDefault("upload_protocol")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "upload_protocol", valid_580043
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

proc call*(call_580045: Call_AndroiddeviceprovisioningPartnersDevicesFindByOwner_580029;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Finds devices claimed for customers. The results only contain devices
  ## registered to the reseller that's identified by the `partnerId` argument.
  ## The customer's devices purchased from other resellers don't appear in the
  ## results.
  ## 
  let valid = call_580045.validator(path, query, header, formData, body)
  let scheme = call_580045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580045.url(scheme.get, call_580045.host, call_580045.base,
                         call_580045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580045, url, valid)

proc call*(call_580046: Call_AndroiddeviceprovisioningPartnersDevicesFindByOwner_580029;
          partnerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningPartnersDevicesFindByOwner
  ## Finds devices claimed for customers. The results only contain devices
  ## registered to the reseller that's identified by the `partnerId` argument.
  ## The customer's devices purchased from other resellers don't appear in the
  ## results.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   partnerId: string (required)
  ##            : Required. The ID of the reseller partner.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580047 = newJObject()
  var query_580048 = newJObject()
  var body_580049 = newJObject()
  add(query_580048, "key", newJString(key))
  add(query_580048, "prettyPrint", newJBool(prettyPrint))
  add(query_580048, "oauth_token", newJString(oauthToken))
  add(query_580048, "$.xgafv", newJString(Xgafv))
  add(path_580047, "partnerId", newJString(partnerId))
  add(query_580048, "alt", newJString(alt))
  add(query_580048, "uploadType", newJString(uploadType))
  add(query_580048, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580049 = body
  add(query_580048, "callback", newJString(callback))
  add(query_580048, "fields", newJString(fields))
  add(query_580048, "access_token", newJString(accessToken))
  add(query_580048, "upload_protocol", newJString(uploadProtocol))
  result = call_580046.call(path_580047, query_580048, nil, nil, body_580049)

var androiddeviceprovisioningPartnersDevicesFindByOwner* = Call_AndroiddeviceprovisioningPartnersDevicesFindByOwner_580029(
    name: "androiddeviceprovisioningPartnersDevicesFindByOwner",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:findByOwner",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesFindByOwner_580030,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesFindByOwner_580031,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesUnclaim_580050 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningPartnersDevicesUnclaim_580052(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesUnclaim_580051(
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
  var valid_580053 = path.getOrDefault("partnerId")
  valid_580053 = validateParameter(valid_580053, JString, required = true,
                                 default = nil)
  if valid_580053 != nil:
    section.add "partnerId", valid_580053
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580054 = query.getOrDefault("key")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "key", valid_580054
  var valid_580055 = query.getOrDefault("prettyPrint")
  valid_580055 = validateParameter(valid_580055, JBool, required = false,
                                 default = newJBool(true))
  if valid_580055 != nil:
    section.add "prettyPrint", valid_580055
  var valid_580056 = query.getOrDefault("oauth_token")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "oauth_token", valid_580056
  var valid_580057 = query.getOrDefault("$.xgafv")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("1"))
  if valid_580057 != nil:
    section.add "$.xgafv", valid_580057
  var valid_580058 = query.getOrDefault("alt")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = newJString("json"))
  if valid_580058 != nil:
    section.add "alt", valid_580058
  var valid_580059 = query.getOrDefault("uploadType")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "uploadType", valid_580059
  var valid_580060 = query.getOrDefault("quotaUser")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "quotaUser", valid_580060
  var valid_580061 = query.getOrDefault("callback")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "callback", valid_580061
  var valid_580062 = query.getOrDefault("fields")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "fields", valid_580062
  var valid_580063 = query.getOrDefault("access_token")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "access_token", valid_580063
  var valid_580064 = query.getOrDefault("upload_protocol")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "upload_protocol", valid_580064
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

proc call*(call_580066: Call_AndroiddeviceprovisioningPartnersDevicesUnclaim_580050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unclaims a device from a customer and removes it from zero-touch
  ## enrollment.
  ## 
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_AndroiddeviceprovisioningPartnersDevicesUnclaim_580050;
          partnerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningPartnersDevicesUnclaim
  ## Unclaims a device from a customer and removes it from zero-touch
  ## enrollment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   partnerId: string (required)
  ##            : Required. The ID of the reseller partner.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580068 = newJObject()
  var query_580069 = newJObject()
  var body_580070 = newJObject()
  add(query_580069, "key", newJString(key))
  add(query_580069, "prettyPrint", newJBool(prettyPrint))
  add(query_580069, "oauth_token", newJString(oauthToken))
  add(query_580069, "$.xgafv", newJString(Xgafv))
  add(path_580068, "partnerId", newJString(partnerId))
  add(query_580069, "alt", newJString(alt))
  add(query_580069, "uploadType", newJString(uploadType))
  add(query_580069, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580070 = body
  add(query_580069, "callback", newJString(callback))
  add(query_580069, "fields", newJString(fields))
  add(query_580069, "access_token", newJString(accessToken))
  add(query_580069, "upload_protocol", newJString(uploadProtocol))
  result = call_580067.call(path_580068, query_580069, nil, nil, body_580070)

var androiddeviceprovisioningPartnersDevicesUnclaim* = Call_AndroiddeviceprovisioningPartnersDevicesUnclaim_580050(
    name: "androiddeviceprovisioningPartnersDevicesUnclaim",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:unclaim",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesUnclaim_580051,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesUnclaim_580052,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_580071 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_580073(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_580072(
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
  var valid_580074 = path.getOrDefault("partnerId")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "partnerId", valid_580074
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580075 = query.getOrDefault("key")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "key", valid_580075
  var valid_580076 = query.getOrDefault("prettyPrint")
  valid_580076 = validateParameter(valid_580076, JBool, required = false,
                                 default = newJBool(true))
  if valid_580076 != nil:
    section.add "prettyPrint", valid_580076
  var valid_580077 = query.getOrDefault("oauth_token")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "oauth_token", valid_580077
  var valid_580078 = query.getOrDefault("$.xgafv")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("1"))
  if valid_580078 != nil:
    section.add "$.xgafv", valid_580078
  var valid_580079 = query.getOrDefault("alt")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = newJString("json"))
  if valid_580079 != nil:
    section.add "alt", valid_580079
  var valid_580080 = query.getOrDefault("uploadType")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "uploadType", valid_580080
  var valid_580081 = query.getOrDefault("quotaUser")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "quotaUser", valid_580081
  var valid_580082 = query.getOrDefault("callback")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "callback", valid_580082
  var valid_580083 = query.getOrDefault("fields")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "fields", valid_580083
  var valid_580084 = query.getOrDefault("access_token")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "access_token", valid_580084
  var valid_580085 = query.getOrDefault("upload_protocol")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "upload_protocol", valid_580085
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

proc call*(call_580087: Call_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_580071;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unclaims a batch of devices for a customer asynchronously. Removes the
  ## devices from zero-touch enrollment. To learn more, read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ## 
  let valid = call_580087.validator(path, query, header, formData, body)
  let scheme = call_580087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580087.url(scheme.get, call_580087.host, call_580087.base,
                         call_580087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580087, url, valid)

proc call*(call_580088: Call_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_580071;
          partnerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningPartnersDevicesUnclaimAsync
  ## Unclaims a batch of devices for a customer asynchronously. Removes the
  ## devices from zero-touch enrollment. To learn more, read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   partnerId: string (required)
  ##            : Required. The reseller partner ID.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580089 = newJObject()
  var query_580090 = newJObject()
  var body_580091 = newJObject()
  add(query_580090, "key", newJString(key))
  add(query_580090, "prettyPrint", newJBool(prettyPrint))
  add(query_580090, "oauth_token", newJString(oauthToken))
  add(query_580090, "$.xgafv", newJString(Xgafv))
  add(path_580089, "partnerId", newJString(partnerId))
  add(query_580090, "alt", newJString(alt))
  add(query_580090, "uploadType", newJString(uploadType))
  add(query_580090, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580091 = body
  add(query_580090, "callback", newJString(callback))
  add(query_580090, "fields", newJString(fields))
  add(query_580090, "access_token", newJString(accessToken))
  add(query_580090, "upload_protocol", newJString(uploadProtocol))
  result = call_580088.call(path_580089, query_580090, nil, nil, body_580091)

var androiddeviceprovisioningPartnersDevicesUnclaimAsync* = Call_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_580071(
    name: "androiddeviceprovisioningPartnersDevicesUnclaimAsync",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:unclaimAsync",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_580072,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_580073,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_580092 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_580094(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_580093(
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
  var valid_580095 = path.getOrDefault("partnerId")
  valid_580095 = validateParameter(valid_580095, JString, required = true,
                                 default = nil)
  if valid_580095 != nil:
    section.add "partnerId", valid_580095
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580096 = query.getOrDefault("key")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "key", valid_580096
  var valid_580097 = query.getOrDefault("prettyPrint")
  valid_580097 = validateParameter(valid_580097, JBool, required = false,
                                 default = newJBool(true))
  if valid_580097 != nil:
    section.add "prettyPrint", valid_580097
  var valid_580098 = query.getOrDefault("oauth_token")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "oauth_token", valid_580098
  var valid_580099 = query.getOrDefault("$.xgafv")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = newJString("1"))
  if valid_580099 != nil:
    section.add "$.xgafv", valid_580099
  var valid_580100 = query.getOrDefault("alt")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = newJString("json"))
  if valid_580100 != nil:
    section.add "alt", valid_580100
  var valid_580101 = query.getOrDefault("uploadType")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "uploadType", valid_580101
  var valid_580102 = query.getOrDefault("quotaUser")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "quotaUser", valid_580102
  var valid_580103 = query.getOrDefault("callback")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "callback", valid_580103
  var valid_580104 = query.getOrDefault("fields")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "fields", valid_580104
  var valid_580105 = query.getOrDefault("access_token")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "access_token", valid_580105
  var valid_580106 = query.getOrDefault("upload_protocol")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "upload_protocol", valid_580106
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

proc call*(call_580108: Call_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_580092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the reseller metadata attached to a batch of devices. This method
  ## updates devices asynchronously and returns an `Operation` that can be used
  ## to track progress. Read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ## 
  let valid = call_580108.validator(path, query, header, formData, body)
  let scheme = call_580108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580108.url(scheme.get, call_580108.host, call_580108.base,
                         call_580108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580108, url, valid)

proc call*(call_580109: Call_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_580092;
          partnerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningPartnersDevicesUpdateMetadataAsync
  ## Updates the reseller metadata attached to a batch of devices. This method
  ## updates devices asynchronously and returns an `Operation` that can be used
  ## to track progress. Read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   partnerId: string (required)
  ##            : Required. The reseller partner ID.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580110 = newJObject()
  var query_580111 = newJObject()
  var body_580112 = newJObject()
  add(query_580111, "key", newJString(key))
  add(query_580111, "prettyPrint", newJBool(prettyPrint))
  add(query_580111, "oauth_token", newJString(oauthToken))
  add(query_580111, "$.xgafv", newJString(Xgafv))
  add(path_580110, "partnerId", newJString(partnerId))
  add(query_580111, "alt", newJString(alt))
  add(query_580111, "uploadType", newJString(uploadType))
  add(query_580111, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580112 = body
  add(query_580111, "callback", newJString(callback))
  add(query_580111, "fields", newJString(fields))
  add(query_580111, "access_token", newJString(accessToken))
  add(query_580111, "upload_protocol", newJString(uploadProtocol))
  result = call_580109.call(path_580110, query_580111, nil, nil, body_580112)

var androiddeviceprovisioningPartnersDevicesUpdateMetadataAsync* = Call_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_580092(
    name: "androiddeviceprovisioningPartnersDevicesUpdateMetadataAsync",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:updateMetadataAsync", validator: validate_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_580093,
    base: "/",
    url: url_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_580094,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesGet_580113 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningPartnersDevicesGet_580115(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersDevicesGet_580114(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The device API resource name in the format
  ## `partners/[PARTNER_ID]/devices/[DEVICE_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580116 = path.getOrDefault("name")
  valid_580116 = validateParameter(valid_580116, JString, required = true,
                                 default = nil)
  if valid_580116 != nil:
    section.add "name", valid_580116
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580117 = query.getOrDefault("key")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "key", valid_580117
  var valid_580118 = query.getOrDefault("prettyPrint")
  valid_580118 = validateParameter(valid_580118, JBool, required = false,
                                 default = newJBool(true))
  if valid_580118 != nil:
    section.add "prettyPrint", valid_580118
  var valid_580119 = query.getOrDefault("oauth_token")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "oauth_token", valid_580119
  var valid_580120 = query.getOrDefault("$.xgafv")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = newJString("1"))
  if valid_580120 != nil:
    section.add "$.xgafv", valid_580120
  var valid_580121 = query.getOrDefault("alt")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = newJString("json"))
  if valid_580121 != nil:
    section.add "alt", valid_580121
  var valid_580122 = query.getOrDefault("uploadType")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "uploadType", valid_580122
  var valid_580123 = query.getOrDefault("quotaUser")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "quotaUser", valid_580123
  var valid_580124 = query.getOrDefault("callback")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "callback", valid_580124
  var valid_580125 = query.getOrDefault("fields")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "fields", valid_580125
  var valid_580126 = query.getOrDefault("access_token")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "access_token", valid_580126
  var valid_580127 = query.getOrDefault("upload_protocol")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "upload_protocol", valid_580127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580128: Call_AndroiddeviceprovisioningPartnersDevicesGet_580113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a device.
  ## 
  let valid = call_580128.validator(path, query, header, formData, body)
  let scheme = call_580128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580128.url(scheme.get, call_580128.host, call_580128.base,
                         call_580128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580128, url, valid)

proc call*(call_580129: Call_AndroiddeviceprovisioningPartnersDevicesGet_580113;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningPartnersDevicesGet
  ## Gets a device.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The device API resource name in the format
  ## `partners/[PARTNER_ID]/devices/[DEVICE_ID]`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580130 = newJObject()
  var query_580131 = newJObject()
  add(query_580131, "key", newJString(key))
  add(query_580131, "prettyPrint", newJBool(prettyPrint))
  add(query_580131, "oauth_token", newJString(oauthToken))
  add(query_580131, "$.xgafv", newJString(Xgafv))
  add(query_580131, "alt", newJString(alt))
  add(query_580131, "uploadType", newJString(uploadType))
  add(query_580131, "quotaUser", newJString(quotaUser))
  add(path_580130, "name", newJString(name))
  add(query_580131, "callback", newJString(callback))
  add(query_580131, "fields", newJString(fields))
  add(query_580131, "access_token", newJString(accessToken))
  add(query_580131, "upload_protocol", newJString(uploadProtocol))
  result = call_580129.call(path_580130, query_580131, nil, nil, nil)

var androiddeviceprovisioningPartnersDevicesGet* = Call_AndroiddeviceprovisioningPartnersDevicesGet_580113(
    name: "androiddeviceprovisioningPartnersDevicesGet", meth: HttpMethod.HttpGet,
    host: "androiddeviceprovisioning.googleapis.com", route: "/v1/{name}",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesGet_580114,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesGet_580115,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersConfigurationsPatch_580151 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningCustomersConfigurationsPatch_580153(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersConfigurationsPatch_580152(
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
  var valid_580154 = path.getOrDefault("name")
  valid_580154 = validateParameter(valid_580154, JString, required = true,
                                 default = nil)
  if valid_580154 != nil:
    section.add "name", valid_580154
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Required. The field mask applied to the target `Configuration` before
  ## updating the fields. To learn more about using field masks, read
  ## [FieldMask](/protocol-buffers/docs/reference/google.protobuf#fieldmask) in
  ## the Protocol Buffers documentation.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580155 = query.getOrDefault("key")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "key", valid_580155
  var valid_580156 = query.getOrDefault("prettyPrint")
  valid_580156 = validateParameter(valid_580156, JBool, required = false,
                                 default = newJBool(true))
  if valid_580156 != nil:
    section.add "prettyPrint", valid_580156
  var valid_580157 = query.getOrDefault("oauth_token")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "oauth_token", valid_580157
  var valid_580158 = query.getOrDefault("$.xgafv")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = newJString("1"))
  if valid_580158 != nil:
    section.add "$.xgafv", valid_580158
  var valid_580159 = query.getOrDefault("alt")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = newJString("json"))
  if valid_580159 != nil:
    section.add "alt", valid_580159
  var valid_580160 = query.getOrDefault("uploadType")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "uploadType", valid_580160
  var valid_580161 = query.getOrDefault("quotaUser")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "quotaUser", valid_580161
  var valid_580162 = query.getOrDefault("updateMask")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "updateMask", valid_580162
  var valid_580163 = query.getOrDefault("callback")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "callback", valid_580163
  var valid_580164 = query.getOrDefault("fields")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "fields", valid_580164
  var valid_580165 = query.getOrDefault("access_token")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "access_token", valid_580165
  var valid_580166 = query.getOrDefault("upload_protocol")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "upload_protocol", valid_580166
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

proc call*(call_580168: Call_AndroiddeviceprovisioningCustomersConfigurationsPatch_580151;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a configuration's field values.
  ## 
  let valid = call_580168.validator(path, query, header, formData, body)
  let scheme = call_580168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580168.url(scheme.get, call_580168.host, call_580168.base,
                         call_580168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580168, url, valid)

proc call*(call_580169: Call_AndroiddeviceprovisioningCustomersConfigurationsPatch_580151;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningCustomersConfigurationsPatch
  ## Updates a configuration's field values.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Output only. The API resource name in the format
  ## `customers/[CUSTOMER_ID]/configurations/[CONFIGURATION_ID]`. Assigned by
  ## the server.
  ##   updateMask: string
  ##             : Required. The field mask applied to the target `Configuration` before
  ## updating the fields. To learn more about using field masks, read
  ## [FieldMask](/protocol-buffers/docs/reference/google.protobuf#fieldmask) in
  ## the Protocol Buffers documentation.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580170 = newJObject()
  var query_580171 = newJObject()
  var body_580172 = newJObject()
  add(query_580171, "key", newJString(key))
  add(query_580171, "prettyPrint", newJBool(prettyPrint))
  add(query_580171, "oauth_token", newJString(oauthToken))
  add(query_580171, "$.xgafv", newJString(Xgafv))
  add(query_580171, "alt", newJString(alt))
  add(query_580171, "uploadType", newJString(uploadType))
  add(query_580171, "quotaUser", newJString(quotaUser))
  add(path_580170, "name", newJString(name))
  add(query_580171, "updateMask", newJString(updateMask))
  if body != nil:
    body_580172 = body
  add(query_580171, "callback", newJString(callback))
  add(query_580171, "fields", newJString(fields))
  add(query_580171, "access_token", newJString(accessToken))
  add(query_580171, "upload_protocol", newJString(uploadProtocol))
  result = call_580169.call(path_580170, query_580171, nil, nil, body_580172)

var androiddeviceprovisioningCustomersConfigurationsPatch* = Call_AndroiddeviceprovisioningCustomersConfigurationsPatch_580151(
    name: "androiddeviceprovisioningCustomersConfigurationsPatch",
    meth: HttpMethod.HttpPatch, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AndroiddeviceprovisioningCustomersConfigurationsPatch_580152,
    base: "/", url: url_AndroiddeviceprovisioningCustomersConfigurationsPatch_580153,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersConfigurationsDelete_580132 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningCustomersConfigurationsDelete_580134(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersConfigurationsDelete_580133(
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
  var valid_580135 = path.getOrDefault("name")
  valid_580135 = validateParameter(valid_580135, JString, required = true,
                                 default = nil)
  if valid_580135 != nil:
    section.add "name", valid_580135
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580136 = query.getOrDefault("key")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "key", valid_580136
  var valid_580137 = query.getOrDefault("prettyPrint")
  valid_580137 = validateParameter(valid_580137, JBool, required = false,
                                 default = newJBool(true))
  if valid_580137 != nil:
    section.add "prettyPrint", valid_580137
  var valid_580138 = query.getOrDefault("oauth_token")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "oauth_token", valid_580138
  var valid_580139 = query.getOrDefault("$.xgafv")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = newJString("1"))
  if valid_580139 != nil:
    section.add "$.xgafv", valid_580139
  var valid_580140 = query.getOrDefault("alt")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("json"))
  if valid_580140 != nil:
    section.add "alt", valid_580140
  var valid_580141 = query.getOrDefault("uploadType")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "uploadType", valid_580141
  var valid_580142 = query.getOrDefault("quotaUser")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "quotaUser", valid_580142
  var valid_580143 = query.getOrDefault("callback")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "callback", valid_580143
  var valid_580144 = query.getOrDefault("fields")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "fields", valid_580144
  var valid_580145 = query.getOrDefault("access_token")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "access_token", valid_580145
  var valid_580146 = query.getOrDefault("upload_protocol")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "upload_protocol", valid_580146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580147: Call_AndroiddeviceprovisioningCustomersConfigurationsDelete_580132;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an unused configuration. The API call fails if the customer has
  ## devices with the configuration applied.
  ## 
  let valid = call_580147.validator(path, query, header, formData, body)
  let scheme = call_580147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580147.url(scheme.get, call_580147.host, call_580147.base,
                         call_580147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580147, url, valid)

proc call*(call_580148: Call_AndroiddeviceprovisioningCustomersConfigurationsDelete_580132;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningCustomersConfigurationsDelete
  ## Deletes an unused configuration. The API call fails if the customer has
  ## devices with the configuration applied.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The configuration to delete. An API resource name in the format
  ## `customers/[CUSTOMER_ID]/configurations/[CONFIGURATION_ID]`. If the
  ## configuration is applied to any devices, the API call fails.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580149 = newJObject()
  var query_580150 = newJObject()
  add(query_580150, "key", newJString(key))
  add(query_580150, "prettyPrint", newJBool(prettyPrint))
  add(query_580150, "oauth_token", newJString(oauthToken))
  add(query_580150, "$.xgafv", newJString(Xgafv))
  add(query_580150, "alt", newJString(alt))
  add(query_580150, "uploadType", newJString(uploadType))
  add(query_580150, "quotaUser", newJString(quotaUser))
  add(path_580149, "name", newJString(name))
  add(query_580150, "callback", newJString(callback))
  add(query_580150, "fields", newJString(fields))
  add(query_580150, "access_token", newJString(accessToken))
  add(query_580150, "upload_protocol", newJString(uploadProtocol))
  result = call_580148.call(path_580149, query_580150, nil, nil, nil)

var androiddeviceprovisioningCustomersConfigurationsDelete* = Call_AndroiddeviceprovisioningCustomersConfigurationsDelete_580132(
    name: "androiddeviceprovisioningCustomersConfigurationsDelete",
    meth: HttpMethod.HttpDelete, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AndroiddeviceprovisioningCustomersConfigurationsDelete_580133,
    base: "/", url: url_AndroiddeviceprovisioningCustomersConfigurationsDelete_580134,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersConfigurationsCreate_580192 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningCustomersConfigurationsCreate_580194(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersConfigurationsCreate_580193(
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
  var valid_580195 = path.getOrDefault("parent")
  valid_580195 = validateParameter(valid_580195, JString, required = true,
                                 default = nil)
  if valid_580195 != nil:
    section.add "parent", valid_580195
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580196 = query.getOrDefault("key")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "key", valid_580196
  var valid_580197 = query.getOrDefault("prettyPrint")
  valid_580197 = validateParameter(valid_580197, JBool, required = false,
                                 default = newJBool(true))
  if valid_580197 != nil:
    section.add "prettyPrint", valid_580197
  var valid_580198 = query.getOrDefault("oauth_token")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "oauth_token", valid_580198
  var valid_580199 = query.getOrDefault("$.xgafv")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = newJString("1"))
  if valid_580199 != nil:
    section.add "$.xgafv", valid_580199
  var valid_580200 = query.getOrDefault("alt")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = newJString("json"))
  if valid_580200 != nil:
    section.add "alt", valid_580200
  var valid_580201 = query.getOrDefault("uploadType")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "uploadType", valid_580201
  var valid_580202 = query.getOrDefault("quotaUser")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "quotaUser", valid_580202
  var valid_580203 = query.getOrDefault("callback")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "callback", valid_580203
  var valid_580204 = query.getOrDefault("fields")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "fields", valid_580204
  var valid_580205 = query.getOrDefault("access_token")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "access_token", valid_580205
  var valid_580206 = query.getOrDefault("upload_protocol")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "upload_protocol", valid_580206
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

proc call*(call_580208: Call_AndroiddeviceprovisioningCustomersConfigurationsCreate_580192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new configuration. Once created, a customer can apply the
  ## configuration to devices.
  ## 
  let valid = call_580208.validator(path, query, header, formData, body)
  let scheme = call_580208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580208.url(scheme.get, call_580208.host, call_580208.base,
                         call_580208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580208, url, valid)

proc call*(call_580209: Call_AndroiddeviceprovisioningCustomersConfigurationsCreate_580192;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningCustomersConfigurationsCreate
  ## Creates a new configuration. Once created, a customer can apply the
  ## configuration to devices.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The customer that manages the configuration. An API resource name
  ## in the format `customers/[CUSTOMER_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580210 = newJObject()
  var query_580211 = newJObject()
  var body_580212 = newJObject()
  add(query_580211, "key", newJString(key))
  add(query_580211, "prettyPrint", newJBool(prettyPrint))
  add(query_580211, "oauth_token", newJString(oauthToken))
  add(query_580211, "$.xgafv", newJString(Xgafv))
  add(query_580211, "alt", newJString(alt))
  add(query_580211, "uploadType", newJString(uploadType))
  add(query_580211, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580212 = body
  add(query_580211, "callback", newJString(callback))
  add(path_580210, "parent", newJString(parent))
  add(query_580211, "fields", newJString(fields))
  add(query_580211, "access_token", newJString(accessToken))
  add(query_580211, "upload_protocol", newJString(uploadProtocol))
  result = call_580209.call(path_580210, query_580211, nil, nil, body_580212)

var androiddeviceprovisioningCustomersConfigurationsCreate* = Call_AndroiddeviceprovisioningCustomersConfigurationsCreate_580192(
    name: "androiddeviceprovisioningCustomersConfigurationsCreate",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/configurations",
    validator: validate_AndroiddeviceprovisioningCustomersConfigurationsCreate_580193,
    base: "/", url: url_AndroiddeviceprovisioningCustomersConfigurationsCreate_580194,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersConfigurationsList_580173 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningCustomersConfigurationsList_580175(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersConfigurationsList_580174(
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
  var valid_580176 = path.getOrDefault("parent")
  valid_580176 = validateParameter(valid_580176, JString, required = true,
                                 default = nil)
  if valid_580176 != nil:
    section.add "parent", valid_580176
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580177 = query.getOrDefault("key")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "key", valid_580177
  var valid_580178 = query.getOrDefault("prettyPrint")
  valid_580178 = validateParameter(valid_580178, JBool, required = false,
                                 default = newJBool(true))
  if valid_580178 != nil:
    section.add "prettyPrint", valid_580178
  var valid_580179 = query.getOrDefault("oauth_token")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "oauth_token", valid_580179
  var valid_580180 = query.getOrDefault("$.xgafv")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = newJString("1"))
  if valid_580180 != nil:
    section.add "$.xgafv", valid_580180
  var valid_580181 = query.getOrDefault("alt")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = newJString("json"))
  if valid_580181 != nil:
    section.add "alt", valid_580181
  var valid_580182 = query.getOrDefault("uploadType")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "uploadType", valid_580182
  var valid_580183 = query.getOrDefault("quotaUser")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "quotaUser", valid_580183
  var valid_580184 = query.getOrDefault("callback")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "callback", valid_580184
  var valid_580185 = query.getOrDefault("fields")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "fields", valid_580185
  var valid_580186 = query.getOrDefault("access_token")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "access_token", valid_580186
  var valid_580187 = query.getOrDefault("upload_protocol")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "upload_protocol", valid_580187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580188: Call_AndroiddeviceprovisioningCustomersConfigurationsList_580173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a customer's configurations.
  ## 
  let valid = call_580188.validator(path, query, header, formData, body)
  let scheme = call_580188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580188.url(scheme.get, call_580188.host, call_580188.base,
                         call_580188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580188, url, valid)

proc call*(call_580189: Call_AndroiddeviceprovisioningCustomersConfigurationsList_580173;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningCustomersConfigurationsList
  ## Lists a customer's configurations.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The customer that manages the listed configurations. An API
  ## resource name in the format `customers/[CUSTOMER_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580190 = newJObject()
  var query_580191 = newJObject()
  add(query_580191, "key", newJString(key))
  add(query_580191, "prettyPrint", newJBool(prettyPrint))
  add(query_580191, "oauth_token", newJString(oauthToken))
  add(query_580191, "$.xgafv", newJString(Xgafv))
  add(query_580191, "alt", newJString(alt))
  add(query_580191, "uploadType", newJString(uploadType))
  add(query_580191, "quotaUser", newJString(quotaUser))
  add(query_580191, "callback", newJString(callback))
  add(path_580190, "parent", newJString(parent))
  add(query_580191, "fields", newJString(fields))
  add(query_580191, "access_token", newJString(accessToken))
  add(query_580191, "upload_protocol", newJString(uploadProtocol))
  result = call_580189.call(path_580190, query_580191, nil, nil, nil)

var androiddeviceprovisioningCustomersConfigurationsList* = Call_AndroiddeviceprovisioningCustomersConfigurationsList_580173(
    name: "androiddeviceprovisioningCustomersConfigurationsList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/configurations",
    validator: validate_AndroiddeviceprovisioningCustomersConfigurationsList_580174,
    base: "/", url: url_AndroiddeviceprovisioningCustomersConfigurationsList_580175,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersCustomersCreate_580234 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningPartnersCustomersCreate_580236(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersCustomersCreate_580235(
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
  var valid_580237 = path.getOrDefault("parent")
  valid_580237 = validateParameter(valid_580237, JString, required = true,
                                 default = nil)
  if valid_580237 != nil:
    section.add "parent", valid_580237
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580238 = query.getOrDefault("key")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "key", valid_580238
  var valid_580239 = query.getOrDefault("prettyPrint")
  valid_580239 = validateParameter(valid_580239, JBool, required = false,
                                 default = newJBool(true))
  if valid_580239 != nil:
    section.add "prettyPrint", valid_580239
  var valid_580240 = query.getOrDefault("oauth_token")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "oauth_token", valid_580240
  var valid_580241 = query.getOrDefault("$.xgafv")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = newJString("1"))
  if valid_580241 != nil:
    section.add "$.xgafv", valid_580241
  var valid_580242 = query.getOrDefault("alt")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = newJString("json"))
  if valid_580242 != nil:
    section.add "alt", valid_580242
  var valid_580243 = query.getOrDefault("uploadType")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "uploadType", valid_580243
  var valid_580244 = query.getOrDefault("quotaUser")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "quotaUser", valid_580244
  var valid_580245 = query.getOrDefault("callback")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "callback", valid_580245
  var valid_580246 = query.getOrDefault("fields")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "fields", valid_580246
  var valid_580247 = query.getOrDefault("access_token")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "access_token", valid_580247
  var valid_580248 = query.getOrDefault("upload_protocol")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "upload_protocol", valid_580248
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

proc call*(call_580250: Call_AndroiddeviceprovisioningPartnersCustomersCreate_580234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a customer for zero-touch enrollment. After the method returns
  ## successfully, admin and owner roles can manage devices and EMM configs
  ## by calling API methods or using their zero-touch enrollment portal.
  ## The customer receives an email that welcomes them to zero-touch enrollment
  ## and explains how to sign into the portal.
  ## 
  let valid = call_580250.validator(path, query, header, formData, body)
  let scheme = call_580250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580250.url(scheme.get, call_580250.host, call_580250.base,
                         call_580250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580250, url, valid)

proc call*(call_580251: Call_AndroiddeviceprovisioningPartnersCustomersCreate_580234;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningPartnersCustomersCreate
  ## Creates a customer for zero-touch enrollment. After the method returns
  ## successfully, admin and owner roles can manage devices and EMM configs
  ## by calling API methods or using their zero-touch enrollment portal.
  ## The customer receives an email that welcomes them to zero-touch enrollment
  ## and explains how to sign into the portal.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The parent resource ID in the format `partners/[PARTNER_ID]` that
  ## identifies the reseller.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580252 = newJObject()
  var query_580253 = newJObject()
  var body_580254 = newJObject()
  add(query_580253, "key", newJString(key))
  add(query_580253, "prettyPrint", newJBool(prettyPrint))
  add(query_580253, "oauth_token", newJString(oauthToken))
  add(query_580253, "$.xgafv", newJString(Xgafv))
  add(query_580253, "alt", newJString(alt))
  add(query_580253, "uploadType", newJString(uploadType))
  add(query_580253, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580254 = body
  add(query_580253, "callback", newJString(callback))
  add(path_580252, "parent", newJString(parent))
  add(query_580253, "fields", newJString(fields))
  add(query_580253, "access_token", newJString(accessToken))
  add(query_580253, "upload_protocol", newJString(uploadProtocol))
  result = call_580251.call(path_580252, query_580253, nil, nil, body_580254)

var androiddeviceprovisioningPartnersCustomersCreate* = Call_AndroiddeviceprovisioningPartnersCustomersCreate_580234(
    name: "androiddeviceprovisioningPartnersCustomersCreate",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/customers",
    validator: validate_AndroiddeviceprovisioningPartnersCustomersCreate_580235,
    base: "/", url: url_AndroiddeviceprovisioningPartnersCustomersCreate_580236,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersVendorsCustomersList_580213 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningPartnersVendorsCustomersList_580215(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersVendorsCustomersList_580214(
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
  var valid_580216 = path.getOrDefault("parent")
  valid_580216 = validateParameter(valid_580216, JString, required = true,
                                 default = nil)
  if valid_580216 != nil:
    section.add "parent", valid_580216
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of results to be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results returned by the server.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580217 = query.getOrDefault("key")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "key", valid_580217
  var valid_580218 = query.getOrDefault("prettyPrint")
  valid_580218 = validateParameter(valid_580218, JBool, required = false,
                                 default = newJBool(true))
  if valid_580218 != nil:
    section.add "prettyPrint", valid_580218
  var valid_580219 = query.getOrDefault("oauth_token")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "oauth_token", valid_580219
  var valid_580220 = query.getOrDefault("$.xgafv")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = newJString("1"))
  if valid_580220 != nil:
    section.add "$.xgafv", valid_580220
  var valid_580221 = query.getOrDefault("pageSize")
  valid_580221 = validateParameter(valid_580221, JInt, required = false, default = nil)
  if valid_580221 != nil:
    section.add "pageSize", valid_580221
  var valid_580222 = query.getOrDefault("alt")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = newJString("json"))
  if valid_580222 != nil:
    section.add "alt", valid_580222
  var valid_580223 = query.getOrDefault("uploadType")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "uploadType", valid_580223
  var valid_580224 = query.getOrDefault("quotaUser")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "quotaUser", valid_580224
  var valid_580225 = query.getOrDefault("pageToken")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "pageToken", valid_580225
  var valid_580226 = query.getOrDefault("callback")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "callback", valid_580226
  var valid_580227 = query.getOrDefault("fields")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "fields", valid_580227
  var valid_580228 = query.getOrDefault("access_token")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "access_token", valid_580228
  var valid_580229 = query.getOrDefault("upload_protocol")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "upload_protocol", valid_580229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580230: Call_AndroiddeviceprovisioningPartnersVendorsCustomersList_580213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the customers of the vendor.
  ## 
  let valid = call_580230.validator(path, query, header, formData, body)
  let scheme = call_580230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580230.url(scheme.get, call_580230.host, call_580230.base,
                         call_580230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580230, url, valid)

proc call*(call_580231: Call_AndroiddeviceprovisioningPartnersVendorsCustomersList_580213;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningPartnersVendorsCustomersList
  ## Lists the customers of the vendor.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results returned by the server.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The resource name in the format
  ## `partners/[PARTNER_ID]/vendors/[VENDOR_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580232 = newJObject()
  var query_580233 = newJObject()
  add(query_580233, "key", newJString(key))
  add(query_580233, "prettyPrint", newJBool(prettyPrint))
  add(query_580233, "oauth_token", newJString(oauthToken))
  add(query_580233, "$.xgafv", newJString(Xgafv))
  add(query_580233, "pageSize", newJInt(pageSize))
  add(query_580233, "alt", newJString(alt))
  add(query_580233, "uploadType", newJString(uploadType))
  add(query_580233, "quotaUser", newJString(quotaUser))
  add(query_580233, "pageToken", newJString(pageToken))
  add(query_580233, "callback", newJString(callback))
  add(path_580232, "parent", newJString(parent))
  add(query_580233, "fields", newJString(fields))
  add(query_580233, "access_token", newJString(accessToken))
  add(query_580233, "upload_protocol", newJString(uploadProtocol))
  result = call_580231.call(path_580232, query_580233, nil, nil, nil)

var androiddeviceprovisioningPartnersVendorsCustomersList* = Call_AndroiddeviceprovisioningPartnersVendorsCustomersList_580213(
    name: "androiddeviceprovisioningPartnersVendorsCustomersList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/customers",
    validator: validate_AndroiddeviceprovisioningPartnersVendorsCustomersList_580214,
    base: "/", url: url_AndroiddeviceprovisioningPartnersVendorsCustomersList_580215,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesList_580255 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningCustomersDevicesList_580257(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersDevicesList_580256(
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
  var valid_580258 = path.getOrDefault("parent")
  valid_580258 = validateParameter(valid_580258, JString, required = true,
                                 default = nil)
  if valid_580258 != nil:
    section.add "parent", valid_580258
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JString
  ##           : The maximum number of devices to show in a page of results.
  ## Must be between 1 and 100 inclusive.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token specifying which result page to return.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580259 = query.getOrDefault("key")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "key", valid_580259
  var valid_580260 = query.getOrDefault("prettyPrint")
  valid_580260 = validateParameter(valid_580260, JBool, required = false,
                                 default = newJBool(true))
  if valid_580260 != nil:
    section.add "prettyPrint", valid_580260
  var valid_580261 = query.getOrDefault("oauth_token")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "oauth_token", valid_580261
  var valid_580262 = query.getOrDefault("$.xgafv")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = newJString("1"))
  if valid_580262 != nil:
    section.add "$.xgafv", valid_580262
  var valid_580263 = query.getOrDefault("pageSize")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "pageSize", valid_580263
  var valid_580264 = query.getOrDefault("alt")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = newJString("json"))
  if valid_580264 != nil:
    section.add "alt", valid_580264
  var valid_580265 = query.getOrDefault("uploadType")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "uploadType", valid_580265
  var valid_580266 = query.getOrDefault("quotaUser")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "quotaUser", valid_580266
  var valid_580267 = query.getOrDefault("pageToken")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "pageToken", valid_580267
  var valid_580268 = query.getOrDefault("callback")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "callback", valid_580268
  var valid_580269 = query.getOrDefault("fields")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "fields", valid_580269
  var valid_580270 = query.getOrDefault("access_token")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "access_token", valid_580270
  var valid_580271 = query.getOrDefault("upload_protocol")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "upload_protocol", valid_580271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580272: Call_AndroiddeviceprovisioningCustomersDevicesList_580255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a customer's devices.
  ## 
  let valid = call_580272.validator(path, query, header, formData, body)
  let scheme = call_580272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580272.url(scheme.get, call_580272.host, call_580272.base,
                         call_580272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580272, url, valid)

proc call*(call_580273: Call_AndroiddeviceprovisioningCustomersDevicesList_580255;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningCustomersDevicesList
  ## Lists a customer's devices.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: string
  ##           : The maximum number of devices to show in a page of results.
  ## Must be between 1 and 100 inclusive.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token specifying which result page to return.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The customer managing the devices. An API resource name in the
  ## format `customers/[CUSTOMER_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580274 = newJObject()
  var query_580275 = newJObject()
  add(query_580275, "key", newJString(key))
  add(query_580275, "prettyPrint", newJBool(prettyPrint))
  add(query_580275, "oauth_token", newJString(oauthToken))
  add(query_580275, "$.xgafv", newJString(Xgafv))
  add(query_580275, "pageSize", newJString(pageSize))
  add(query_580275, "alt", newJString(alt))
  add(query_580275, "uploadType", newJString(uploadType))
  add(query_580275, "quotaUser", newJString(quotaUser))
  add(query_580275, "pageToken", newJString(pageToken))
  add(query_580275, "callback", newJString(callback))
  add(path_580274, "parent", newJString(parent))
  add(query_580275, "fields", newJString(fields))
  add(query_580275, "access_token", newJString(accessToken))
  add(query_580275, "upload_protocol", newJString(uploadProtocol))
  result = call_580273.call(path_580274, query_580275, nil, nil, nil)

var androiddeviceprovisioningCustomersDevicesList* = Call_AndroiddeviceprovisioningCustomersDevicesList_580255(
    name: "androiddeviceprovisioningCustomersDevicesList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/devices",
    validator: validate_AndroiddeviceprovisioningCustomersDevicesList_580256,
    base: "/", url: url_AndroiddeviceprovisioningCustomersDevicesList_580257,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_580276 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_580278(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_580277(
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
  var valid_580279 = path.getOrDefault("parent")
  valid_580279 = validateParameter(valid_580279, JString, required = true,
                                 default = nil)
  if valid_580279 != nil:
    section.add "parent", valid_580279
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580280 = query.getOrDefault("key")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "key", valid_580280
  var valid_580281 = query.getOrDefault("prettyPrint")
  valid_580281 = validateParameter(valid_580281, JBool, required = false,
                                 default = newJBool(true))
  if valid_580281 != nil:
    section.add "prettyPrint", valid_580281
  var valid_580282 = query.getOrDefault("oauth_token")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "oauth_token", valid_580282
  var valid_580283 = query.getOrDefault("$.xgafv")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = newJString("1"))
  if valid_580283 != nil:
    section.add "$.xgafv", valid_580283
  var valid_580284 = query.getOrDefault("alt")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = newJString("json"))
  if valid_580284 != nil:
    section.add "alt", valid_580284
  var valid_580285 = query.getOrDefault("uploadType")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "uploadType", valid_580285
  var valid_580286 = query.getOrDefault("quotaUser")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "quotaUser", valid_580286
  var valid_580287 = query.getOrDefault("callback")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "callback", valid_580287
  var valid_580288 = query.getOrDefault("fields")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "fields", valid_580288
  var valid_580289 = query.getOrDefault("access_token")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "access_token", valid_580289
  var valid_580290 = query.getOrDefault("upload_protocol")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "upload_protocol", valid_580290
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

proc call*(call_580292: Call_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_580276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Applies a Configuration to the device to register the device for zero-touch
  ## enrollment. After applying a configuration to a device, the device
  ## automatically provisions itself on first boot, or next factory reset.
  ## 
  let valid = call_580292.validator(path, query, header, formData, body)
  let scheme = call_580292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580292.url(scheme.get, call_580292.host, call_580292.base,
                         call_580292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580292, url, valid)

proc call*(call_580293: Call_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_580276;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningCustomersDevicesApplyConfiguration
  ## Applies a Configuration to the device to register the device for zero-touch
  ## enrollment. After applying a configuration to a device, the device
  ## automatically provisions itself on first boot, or next factory reset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The customer managing the device. An API resource name in the
  ## format `customers/[CUSTOMER_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580294 = newJObject()
  var query_580295 = newJObject()
  var body_580296 = newJObject()
  add(query_580295, "key", newJString(key))
  add(query_580295, "prettyPrint", newJBool(prettyPrint))
  add(query_580295, "oauth_token", newJString(oauthToken))
  add(query_580295, "$.xgafv", newJString(Xgafv))
  add(query_580295, "alt", newJString(alt))
  add(query_580295, "uploadType", newJString(uploadType))
  add(query_580295, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580296 = body
  add(query_580295, "callback", newJString(callback))
  add(path_580294, "parent", newJString(parent))
  add(query_580295, "fields", newJString(fields))
  add(query_580295, "access_token", newJString(accessToken))
  add(query_580295, "upload_protocol", newJString(uploadProtocol))
  result = call_580293.call(path_580294, query_580295, nil, nil, body_580296)

var androiddeviceprovisioningCustomersDevicesApplyConfiguration* = Call_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_580276(
    name: "androiddeviceprovisioningCustomersDevicesApplyConfiguration",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/devices:applyConfiguration", validator: validate_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_580277,
    base: "/",
    url: url_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_580278,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_580297 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_580299(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_580298(
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
  var valid_580300 = path.getOrDefault("parent")
  valid_580300 = validateParameter(valid_580300, JString, required = true,
                                 default = nil)
  if valid_580300 != nil:
    section.add "parent", valid_580300
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580301 = query.getOrDefault("key")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "key", valid_580301
  var valid_580302 = query.getOrDefault("prettyPrint")
  valid_580302 = validateParameter(valid_580302, JBool, required = false,
                                 default = newJBool(true))
  if valid_580302 != nil:
    section.add "prettyPrint", valid_580302
  var valid_580303 = query.getOrDefault("oauth_token")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "oauth_token", valid_580303
  var valid_580304 = query.getOrDefault("$.xgafv")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = newJString("1"))
  if valid_580304 != nil:
    section.add "$.xgafv", valid_580304
  var valid_580305 = query.getOrDefault("alt")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = newJString("json"))
  if valid_580305 != nil:
    section.add "alt", valid_580305
  var valid_580306 = query.getOrDefault("uploadType")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "uploadType", valid_580306
  var valid_580307 = query.getOrDefault("quotaUser")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "quotaUser", valid_580307
  var valid_580308 = query.getOrDefault("callback")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "callback", valid_580308
  var valid_580309 = query.getOrDefault("fields")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "fields", valid_580309
  var valid_580310 = query.getOrDefault("access_token")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "access_token", valid_580310
  var valid_580311 = query.getOrDefault("upload_protocol")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "upload_protocol", valid_580311
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

proc call*(call_580313: Call_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_580297;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a configuration from device.
  ## 
  let valid = call_580313.validator(path, query, header, formData, body)
  let scheme = call_580313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580313.url(scheme.get, call_580313.host, call_580313.base,
                         call_580313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580313, url, valid)

proc call*(call_580314: Call_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_580297;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningCustomersDevicesRemoveConfiguration
  ## Removes a configuration from device.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The customer managing the device in the format
  ## `customers/[CUSTOMER_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580315 = newJObject()
  var query_580316 = newJObject()
  var body_580317 = newJObject()
  add(query_580316, "key", newJString(key))
  add(query_580316, "prettyPrint", newJBool(prettyPrint))
  add(query_580316, "oauth_token", newJString(oauthToken))
  add(query_580316, "$.xgafv", newJString(Xgafv))
  add(query_580316, "alt", newJString(alt))
  add(query_580316, "uploadType", newJString(uploadType))
  add(query_580316, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580317 = body
  add(query_580316, "callback", newJString(callback))
  add(path_580315, "parent", newJString(parent))
  add(query_580316, "fields", newJString(fields))
  add(query_580316, "access_token", newJString(accessToken))
  add(query_580316, "upload_protocol", newJString(uploadProtocol))
  result = call_580314.call(path_580315, query_580316, nil, nil, body_580317)

var androiddeviceprovisioningCustomersDevicesRemoveConfiguration* = Call_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_580297(
    name: "androiddeviceprovisioningCustomersDevicesRemoveConfiguration",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/devices:removeConfiguration", validator: validate_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_580298,
    base: "/",
    url: url_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_580299,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesUnclaim_580318 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningCustomersDevicesUnclaim_580320(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersDevicesUnclaim_580319(
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
  var valid_580321 = path.getOrDefault("parent")
  valid_580321 = validateParameter(valid_580321, JString, required = true,
                                 default = nil)
  if valid_580321 != nil:
    section.add "parent", valid_580321
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580322 = query.getOrDefault("key")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "key", valid_580322
  var valid_580323 = query.getOrDefault("prettyPrint")
  valid_580323 = validateParameter(valid_580323, JBool, required = false,
                                 default = newJBool(true))
  if valid_580323 != nil:
    section.add "prettyPrint", valid_580323
  var valid_580324 = query.getOrDefault("oauth_token")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "oauth_token", valid_580324
  var valid_580325 = query.getOrDefault("$.xgafv")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = newJString("1"))
  if valid_580325 != nil:
    section.add "$.xgafv", valid_580325
  var valid_580326 = query.getOrDefault("alt")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = newJString("json"))
  if valid_580326 != nil:
    section.add "alt", valid_580326
  var valid_580327 = query.getOrDefault("uploadType")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "uploadType", valid_580327
  var valid_580328 = query.getOrDefault("quotaUser")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "quotaUser", valid_580328
  var valid_580329 = query.getOrDefault("callback")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "callback", valid_580329
  var valid_580330 = query.getOrDefault("fields")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "fields", valid_580330
  var valid_580331 = query.getOrDefault("access_token")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "access_token", valid_580331
  var valid_580332 = query.getOrDefault("upload_protocol")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "upload_protocol", valid_580332
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

proc call*(call_580334: Call_AndroiddeviceprovisioningCustomersDevicesUnclaim_580318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unclaims a device from a customer and removes it from zero-touch
  ## enrollment.
  ## 
  ## After removing a device, a customer must contact their reseller to register
  ## the device into zero-touch enrollment again.
  ## 
  let valid = call_580334.validator(path, query, header, formData, body)
  let scheme = call_580334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580334.url(scheme.get, call_580334.host, call_580334.base,
                         call_580334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580334, url, valid)

proc call*(call_580335: Call_AndroiddeviceprovisioningCustomersDevicesUnclaim_580318;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningCustomersDevicesUnclaim
  ## Unclaims a device from a customer and removes it from zero-touch
  ## enrollment.
  ## 
  ## After removing a device, a customer must contact their reseller to register
  ## the device into zero-touch enrollment again.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The customer managing the device. An API resource name in the
  ## format `customers/[CUSTOMER_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580336 = newJObject()
  var query_580337 = newJObject()
  var body_580338 = newJObject()
  add(query_580337, "key", newJString(key))
  add(query_580337, "prettyPrint", newJBool(prettyPrint))
  add(query_580337, "oauth_token", newJString(oauthToken))
  add(query_580337, "$.xgafv", newJString(Xgafv))
  add(query_580337, "alt", newJString(alt))
  add(query_580337, "uploadType", newJString(uploadType))
  add(query_580337, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580338 = body
  add(query_580337, "callback", newJString(callback))
  add(path_580336, "parent", newJString(parent))
  add(query_580337, "fields", newJString(fields))
  add(query_580337, "access_token", newJString(accessToken))
  add(query_580337, "upload_protocol", newJString(uploadProtocol))
  result = call_580335.call(path_580336, query_580337, nil, nil, body_580338)

var androiddeviceprovisioningCustomersDevicesUnclaim* = Call_AndroiddeviceprovisioningCustomersDevicesUnclaim_580318(
    name: "androiddeviceprovisioningCustomersDevicesUnclaim",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/devices:unclaim",
    validator: validate_AndroiddeviceprovisioningCustomersDevicesUnclaim_580319,
    base: "/", url: url_AndroiddeviceprovisioningCustomersDevicesUnclaim_580320,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDpcsList_580339 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningCustomersDpcsList_580341(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningCustomersDpcsList_580340(path: JsonNode;
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
  var valid_580342 = path.getOrDefault("parent")
  valid_580342 = validateParameter(valid_580342, JString, required = true,
                                 default = nil)
  if valid_580342 != nil:
    section.add "parent", valid_580342
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580343 = query.getOrDefault("key")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "key", valid_580343
  var valid_580344 = query.getOrDefault("prettyPrint")
  valid_580344 = validateParameter(valid_580344, JBool, required = false,
                                 default = newJBool(true))
  if valid_580344 != nil:
    section.add "prettyPrint", valid_580344
  var valid_580345 = query.getOrDefault("oauth_token")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "oauth_token", valid_580345
  var valid_580346 = query.getOrDefault("$.xgafv")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = newJString("1"))
  if valid_580346 != nil:
    section.add "$.xgafv", valid_580346
  var valid_580347 = query.getOrDefault("alt")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = newJString("json"))
  if valid_580347 != nil:
    section.add "alt", valid_580347
  var valid_580348 = query.getOrDefault("uploadType")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "uploadType", valid_580348
  var valid_580349 = query.getOrDefault("quotaUser")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "quotaUser", valid_580349
  var valid_580350 = query.getOrDefault("callback")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "callback", valid_580350
  var valid_580351 = query.getOrDefault("fields")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "fields", valid_580351
  var valid_580352 = query.getOrDefault("access_token")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "access_token", valid_580352
  var valid_580353 = query.getOrDefault("upload_protocol")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "upload_protocol", valid_580353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580354: Call_AndroiddeviceprovisioningCustomersDpcsList_580339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the DPCs (device policy controllers) that support zero-touch
  ## enrollment.
  ## 
  let valid = call_580354.validator(path, query, header, formData, body)
  let scheme = call_580354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580354.url(scheme.get, call_580354.host, call_580354.base,
                         call_580354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580354, url, valid)

proc call*(call_580355: Call_AndroiddeviceprovisioningCustomersDpcsList_580339;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningCustomersDpcsList
  ## Lists the DPCs (device policy controllers) that support zero-touch
  ## enrollment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The customer that can use the DPCs in configurations. An API
  ## resource name in the format `customers/[CUSTOMER_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580356 = newJObject()
  var query_580357 = newJObject()
  add(query_580357, "key", newJString(key))
  add(query_580357, "prettyPrint", newJBool(prettyPrint))
  add(query_580357, "oauth_token", newJString(oauthToken))
  add(query_580357, "$.xgafv", newJString(Xgafv))
  add(query_580357, "alt", newJString(alt))
  add(query_580357, "uploadType", newJString(uploadType))
  add(query_580357, "quotaUser", newJString(quotaUser))
  add(query_580357, "callback", newJString(callback))
  add(path_580356, "parent", newJString(parent))
  add(query_580357, "fields", newJString(fields))
  add(query_580357, "access_token", newJString(accessToken))
  add(query_580357, "upload_protocol", newJString(uploadProtocol))
  result = call_580355.call(path_580356, query_580357, nil, nil, nil)

var androiddeviceprovisioningCustomersDpcsList* = Call_AndroiddeviceprovisioningCustomersDpcsList_580339(
    name: "androiddeviceprovisioningCustomersDpcsList", meth: HttpMethod.HttpGet,
    host: "androiddeviceprovisioning.googleapis.com", route: "/v1/{parent}/dpcs",
    validator: validate_AndroiddeviceprovisioningCustomersDpcsList_580340,
    base: "/", url: url_AndroiddeviceprovisioningCustomersDpcsList_580341,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersVendorsList_580358 = ref object of OpenApiRestCall_579364
proc url_AndroiddeviceprovisioningPartnersVendorsList_580360(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AndroiddeviceprovisioningPartnersVendorsList_580359(path: JsonNode;
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
  var valid_580361 = path.getOrDefault("parent")
  valid_580361 = validateParameter(valid_580361, JString, required = true,
                                 default = nil)
  if valid_580361 != nil:
    section.add "parent", valid_580361
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of results to be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results returned by the server.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580362 = query.getOrDefault("key")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "key", valid_580362
  var valid_580363 = query.getOrDefault("prettyPrint")
  valid_580363 = validateParameter(valid_580363, JBool, required = false,
                                 default = newJBool(true))
  if valid_580363 != nil:
    section.add "prettyPrint", valid_580363
  var valid_580364 = query.getOrDefault("oauth_token")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "oauth_token", valid_580364
  var valid_580365 = query.getOrDefault("$.xgafv")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = newJString("1"))
  if valid_580365 != nil:
    section.add "$.xgafv", valid_580365
  var valid_580366 = query.getOrDefault("pageSize")
  valid_580366 = validateParameter(valid_580366, JInt, required = false, default = nil)
  if valid_580366 != nil:
    section.add "pageSize", valid_580366
  var valid_580367 = query.getOrDefault("alt")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = newJString("json"))
  if valid_580367 != nil:
    section.add "alt", valid_580367
  var valid_580368 = query.getOrDefault("uploadType")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "uploadType", valid_580368
  var valid_580369 = query.getOrDefault("quotaUser")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "quotaUser", valid_580369
  var valid_580370 = query.getOrDefault("pageToken")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "pageToken", valid_580370
  var valid_580371 = query.getOrDefault("callback")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "callback", valid_580371
  var valid_580372 = query.getOrDefault("fields")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "fields", valid_580372
  var valid_580373 = query.getOrDefault("access_token")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "access_token", valid_580373
  var valid_580374 = query.getOrDefault("upload_protocol")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "upload_protocol", valid_580374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580375: Call_AndroiddeviceprovisioningPartnersVendorsList_580358;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the vendors of the partner.
  ## 
  let valid = call_580375.validator(path, query, header, formData, body)
  let scheme = call_580375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580375.url(scheme.get, call_580375.host, call_580375.base,
                         call_580375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580375, url, valid)

proc call*(call_580376: Call_AndroiddeviceprovisioningPartnersVendorsList_580358;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningPartnersVendorsList
  ## Lists the vendors of the partner.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results returned by the server.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The resource name in the format `partners/[PARTNER_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580377 = newJObject()
  var query_580378 = newJObject()
  add(query_580378, "key", newJString(key))
  add(query_580378, "prettyPrint", newJBool(prettyPrint))
  add(query_580378, "oauth_token", newJString(oauthToken))
  add(query_580378, "$.xgafv", newJString(Xgafv))
  add(query_580378, "pageSize", newJInt(pageSize))
  add(query_580378, "alt", newJString(alt))
  add(query_580378, "uploadType", newJString(uploadType))
  add(query_580378, "quotaUser", newJString(quotaUser))
  add(query_580378, "pageToken", newJString(pageToken))
  add(query_580378, "callback", newJString(callback))
  add(path_580377, "parent", newJString(parent))
  add(query_580378, "fields", newJString(fields))
  add(query_580378, "access_token", newJString(accessToken))
  add(query_580378, "upload_protocol", newJString(uploadProtocol))
  result = call_580376.call(path_580377, query_580378, nil, nil, nil)

var androiddeviceprovisioningPartnersVendorsList* = Call_AndroiddeviceprovisioningPartnersVendorsList_580358(
    name: "androiddeviceprovisioningPartnersVendorsList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/vendors",
    validator: validate_AndroiddeviceprovisioningPartnersVendorsList_580359,
    base: "/", url: url_AndroiddeviceprovisioningPartnersVendorsList_580360,
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
