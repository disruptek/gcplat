
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  Call_AndroiddeviceprovisioningCustomersList_578610 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningCustomersList_578612(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroiddeviceprovisioningCustomersList_578611(path: JsonNode;
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
  var valid_578724 = query.getOrDefault("key")
  valid_578724 = validateParameter(valid_578724, JString, required = false,
                                 default = nil)
  if valid_578724 != nil:
    section.add "key", valid_578724
  var valid_578738 = query.getOrDefault("prettyPrint")
  valid_578738 = validateParameter(valid_578738, JBool, required = false,
                                 default = newJBool(true))
  if valid_578738 != nil:
    section.add "prettyPrint", valid_578738
  var valid_578739 = query.getOrDefault("oauth_token")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "oauth_token", valid_578739
  var valid_578740 = query.getOrDefault("$.xgafv")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = newJString("1"))
  if valid_578740 != nil:
    section.add "$.xgafv", valid_578740
  var valid_578741 = query.getOrDefault("pageSize")
  valid_578741 = validateParameter(valid_578741, JInt, required = false, default = nil)
  if valid_578741 != nil:
    section.add "pageSize", valid_578741
  var valid_578742 = query.getOrDefault("alt")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = newJString("json"))
  if valid_578742 != nil:
    section.add "alt", valid_578742
  var valid_578743 = query.getOrDefault("uploadType")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "uploadType", valid_578743
  var valid_578744 = query.getOrDefault("quotaUser")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "quotaUser", valid_578744
  var valid_578745 = query.getOrDefault("pageToken")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "pageToken", valid_578745
  var valid_578746 = query.getOrDefault("callback")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "callback", valid_578746
  var valid_578747 = query.getOrDefault("fields")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "fields", valid_578747
  var valid_578748 = query.getOrDefault("access_token")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "access_token", valid_578748
  var valid_578749 = query.getOrDefault("upload_protocol")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "upload_protocol", valid_578749
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578772: Call_AndroiddeviceprovisioningCustomersList_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the user's customer accounts.
  ## 
  let valid = call_578772.validator(path, query, header, formData, body)
  let scheme = call_578772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578772.url(scheme.get, call_578772.host, call_578772.base,
                         call_578772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578772, url, valid)

proc call*(call_578843: Call_AndroiddeviceprovisioningCustomersList_578610;
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
  var query_578844 = newJObject()
  add(query_578844, "key", newJString(key))
  add(query_578844, "prettyPrint", newJBool(prettyPrint))
  add(query_578844, "oauth_token", newJString(oauthToken))
  add(query_578844, "$.xgafv", newJString(Xgafv))
  add(query_578844, "pageSize", newJInt(pageSize))
  add(query_578844, "alt", newJString(alt))
  add(query_578844, "uploadType", newJString(uploadType))
  add(query_578844, "quotaUser", newJString(quotaUser))
  add(query_578844, "pageToken", newJString(pageToken))
  add(query_578844, "callback", newJString(callback))
  add(query_578844, "fields", newJString(fields))
  add(query_578844, "access_token", newJString(accessToken))
  add(query_578844, "upload_protocol", newJString(uploadProtocol))
  result = call_578843.call(nil, query_578844, nil, nil, nil)

var androiddeviceprovisioningCustomersList* = Call_AndroiddeviceprovisioningCustomersList_578610(
    name: "androiddeviceprovisioningCustomersList", meth: HttpMethod.HttpGet,
    host: "androiddeviceprovisioning.googleapis.com", route: "/v1/customers",
    validator: validate_AndroiddeviceprovisioningCustomersList_578611, base: "/",
    url: url_AndroiddeviceprovisioningCustomersList_578612,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesMetadata_578884 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningPartnersDevicesMetadata_578886(
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

proc validate_AndroiddeviceprovisioningPartnersDevicesMetadata_578885(
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
  var valid_578901 = path.getOrDefault("metadataOwnerId")
  valid_578901 = validateParameter(valid_578901, JString, required = true,
                                 default = nil)
  if valid_578901 != nil:
    section.add "metadataOwnerId", valid_578901
  var valid_578902 = path.getOrDefault("deviceId")
  valid_578902 = validateParameter(valid_578902, JString, required = true,
                                 default = nil)
  if valid_578902 != nil:
    section.add "deviceId", valid_578902
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
  var valid_578903 = query.getOrDefault("key")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "key", valid_578903
  var valid_578904 = query.getOrDefault("prettyPrint")
  valid_578904 = validateParameter(valid_578904, JBool, required = false,
                                 default = newJBool(true))
  if valid_578904 != nil:
    section.add "prettyPrint", valid_578904
  var valid_578905 = query.getOrDefault("oauth_token")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "oauth_token", valid_578905
  var valid_578906 = query.getOrDefault("$.xgafv")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString("1"))
  if valid_578906 != nil:
    section.add "$.xgafv", valid_578906
  var valid_578907 = query.getOrDefault("alt")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = newJString("json"))
  if valid_578907 != nil:
    section.add "alt", valid_578907
  var valid_578908 = query.getOrDefault("uploadType")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "uploadType", valid_578908
  var valid_578909 = query.getOrDefault("quotaUser")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "quotaUser", valid_578909
  var valid_578910 = query.getOrDefault("callback")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "callback", valid_578910
  var valid_578911 = query.getOrDefault("fields")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "fields", valid_578911
  var valid_578912 = query.getOrDefault("access_token")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "access_token", valid_578912
  var valid_578913 = query.getOrDefault("upload_protocol")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "upload_protocol", valid_578913
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

proc call*(call_578915: Call_AndroiddeviceprovisioningPartnersDevicesMetadata_578884;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates reseller metadata associated with the device.
  ## 
  let valid = call_578915.validator(path, query, header, formData, body)
  let scheme = call_578915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578915.url(scheme.get, call_578915.host, call_578915.base,
                         call_578915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578915, url, valid)

proc call*(call_578916: Call_AndroiddeviceprovisioningPartnersDevicesMetadata_578884;
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
  var path_578917 = newJObject()
  var query_578918 = newJObject()
  var body_578919 = newJObject()
  add(query_578918, "key", newJString(key))
  add(query_578918, "prettyPrint", newJBool(prettyPrint))
  add(query_578918, "oauth_token", newJString(oauthToken))
  add(query_578918, "$.xgafv", newJString(Xgafv))
  add(query_578918, "alt", newJString(alt))
  add(query_578918, "uploadType", newJString(uploadType))
  add(query_578918, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578919 = body
  add(query_578918, "callback", newJString(callback))
  add(path_578917, "metadataOwnerId", newJString(metadataOwnerId))
  add(query_578918, "fields", newJString(fields))
  add(query_578918, "access_token", newJString(accessToken))
  add(query_578918, "upload_protocol", newJString(uploadProtocol))
  add(path_578917, "deviceId", newJString(deviceId))
  result = call_578916.call(path_578917, query_578918, nil, nil, body_578919)

var androiddeviceprovisioningPartnersDevicesMetadata* = Call_AndroiddeviceprovisioningPartnersDevicesMetadata_578884(
    name: "androiddeviceprovisioningPartnersDevicesMetadata",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{metadataOwnerId}/devices/{deviceId}/metadata",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesMetadata_578885,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesMetadata_578886,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersCustomersList_578920 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningPartnersCustomersList_578922(protocol: Scheme;
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

proc validate_AndroiddeviceprovisioningPartnersCustomersList_578921(
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
  var valid_578923 = path.getOrDefault("partnerId")
  valid_578923 = validateParameter(valid_578923, JString, required = true,
                                 default = nil)
  if valid_578923 != nil:
    section.add "partnerId", valid_578923
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
  var valid_578924 = query.getOrDefault("key")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "key", valid_578924
  var valid_578925 = query.getOrDefault("prettyPrint")
  valid_578925 = validateParameter(valid_578925, JBool, required = false,
                                 default = newJBool(true))
  if valid_578925 != nil:
    section.add "prettyPrint", valid_578925
  var valid_578926 = query.getOrDefault("oauth_token")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "oauth_token", valid_578926
  var valid_578927 = query.getOrDefault("$.xgafv")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = newJString("1"))
  if valid_578927 != nil:
    section.add "$.xgafv", valid_578927
  var valid_578928 = query.getOrDefault("pageSize")
  valid_578928 = validateParameter(valid_578928, JInt, required = false, default = nil)
  if valid_578928 != nil:
    section.add "pageSize", valid_578928
  var valid_578929 = query.getOrDefault("alt")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = newJString("json"))
  if valid_578929 != nil:
    section.add "alt", valid_578929
  var valid_578930 = query.getOrDefault("uploadType")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "uploadType", valid_578930
  var valid_578931 = query.getOrDefault("quotaUser")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "quotaUser", valid_578931
  var valid_578932 = query.getOrDefault("pageToken")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "pageToken", valid_578932
  var valid_578933 = query.getOrDefault("callback")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "callback", valid_578933
  var valid_578934 = query.getOrDefault("fields")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "fields", valid_578934
  var valid_578935 = query.getOrDefault("access_token")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "access_token", valid_578935
  var valid_578936 = query.getOrDefault("upload_protocol")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "upload_protocol", valid_578936
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578937: Call_AndroiddeviceprovisioningPartnersCustomersList_578920;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the customers that are enrolled to the reseller identified by the
  ## `partnerId` argument. This list includes customers that the reseller
  ## created and customers that enrolled themselves using the portal.
  ## 
  let valid = call_578937.validator(path, query, header, formData, body)
  let scheme = call_578937.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578937.url(scheme.get, call_578937.host, call_578937.base,
                         call_578937.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578937, url, valid)

proc call*(call_578938: Call_AndroiddeviceprovisioningPartnersCustomersList_578920;
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
  var path_578939 = newJObject()
  var query_578940 = newJObject()
  add(query_578940, "key", newJString(key))
  add(query_578940, "prettyPrint", newJBool(prettyPrint))
  add(query_578940, "oauth_token", newJString(oauthToken))
  add(query_578940, "$.xgafv", newJString(Xgafv))
  add(path_578939, "partnerId", newJString(partnerId))
  add(query_578940, "pageSize", newJInt(pageSize))
  add(query_578940, "alt", newJString(alt))
  add(query_578940, "uploadType", newJString(uploadType))
  add(query_578940, "quotaUser", newJString(quotaUser))
  add(query_578940, "pageToken", newJString(pageToken))
  add(query_578940, "callback", newJString(callback))
  add(query_578940, "fields", newJString(fields))
  add(query_578940, "access_token", newJString(accessToken))
  add(query_578940, "upload_protocol", newJString(uploadProtocol))
  result = call_578938.call(path_578939, query_578940, nil, nil, nil)

var androiddeviceprovisioningPartnersCustomersList* = Call_AndroiddeviceprovisioningPartnersCustomersList_578920(
    name: "androiddeviceprovisioningPartnersCustomersList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/customers",
    validator: validate_AndroiddeviceprovisioningPartnersCustomersList_578921,
    base: "/", url: url_AndroiddeviceprovisioningPartnersCustomersList_578922,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesClaim_578941 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningPartnersDevicesClaim_578943(protocol: Scheme;
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

proc validate_AndroiddeviceprovisioningPartnersDevicesClaim_578942(
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
  var valid_578944 = path.getOrDefault("partnerId")
  valid_578944 = validateParameter(valid_578944, JString, required = true,
                                 default = nil)
  if valid_578944 != nil:
    section.add "partnerId", valid_578944
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
  var valid_578945 = query.getOrDefault("key")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "key", valid_578945
  var valid_578946 = query.getOrDefault("prettyPrint")
  valid_578946 = validateParameter(valid_578946, JBool, required = false,
                                 default = newJBool(true))
  if valid_578946 != nil:
    section.add "prettyPrint", valid_578946
  var valid_578947 = query.getOrDefault("oauth_token")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "oauth_token", valid_578947
  var valid_578948 = query.getOrDefault("$.xgafv")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = newJString("1"))
  if valid_578948 != nil:
    section.add "$.xgafv", valid_578948
  var valid_578949 = query.getOrDefault("alt")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("json"))
  if valid_578949 != nil:
    section.add "alt", valid_578949
  var valid_578950 = query.getOrDefault("uploadType")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "uploadType", valid_578950
  var valid_578951 = query.getOrDefault("quotaUser")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "quotaUser", valid_578951
  var valid_578952 = query.getOrDefault("callback")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "callback", valid_578952
  var valid_578953 = query.getOrDefault("fields")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "fields", valid_578953
  var valid_578954 = query.getOrDefault("access_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "access_token", valid_578954
  var valid_578955 = query.getOrDefault("upload_protocol")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "upload_protocol", valid_578955
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

proc call*(call_578957: Call_AndroiddeviceprovisioningPartnersDevicesClaim_578941;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Claims a device for a customer and adds it to zero-touch enrollment. If the
  ## device is already claimed by another customer, the call returns an error.
  ## 
  let valid = call_578957.validator(path, query, header, formData, body)
  let scheme = call_578957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578957.url(scheme.get, call_578957.host, call_578957.base,
                         call_578957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578957, url, valid)

proc call*(call_578958: Call_AndroiddeviceprovisioningPartnersDevicesClaim_578941;
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
  var path_578959 = newJObject()
  var query_578960 = newJObject()
  var body_578961 = newJObject()
  add(query_578960, "key", newJString(key))
  add(query_578960, "prettyPrint", newJBool(prettyPrint))
  add(query_578960, "oauth_token", newJString(oauthToken))
  add(query_578960, "$.xgafv", newJString(Xgafv))
  add(path_578959, "partnerId", newJString(partnerId))
  add(query_578960, "alt", newJString(alt))
  add(query_578960, "uploadType", newJString(uploadType))
  add(query_578960, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578961 = body
  add(query_578960, "callback", newJString(callback))
  add(query_578960, "fields", newJString(fields))
  add(query_578960, "access_token", newJString(accessToken))
  add(query_578960, "upload_protocol", newJString(uploadProtocol))
  result = call_578958.call(path_578959, query_578960, nil, nil, body_578961)

var androiddeviceprovisioningPartnersDevicesClaim* = Call_AndroiddeviceprovisioningPartnersDevicesClaim_578941(
    name: "androiddeviceprovisioningPartnersDevicesClaim",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:claim",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesClaim_578942,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesClaim_578943,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesClaimAsync_578962 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningPartnersDevicesClaimAsync_578964(
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

proc validate_AndroiddeviceprovisioningPartnersDevicesClaimAsync_578963(
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
  var valid_578965 = path.getOrDefault("partnerId")
  valid_578965 = validateParameter(valid_578965, JString, required = true,
                                 default = nil)
  if valid_578965 != nil:
    section.add "partnerId", valid_578965
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
  var valid_578966 = query.getOrDefault("key")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "key", valid_578966
  var valid_578967 = query.getOrDefault("prettyPrint")
  valid_578967 = validateParameter(valid_578967, JBool, required = false,
                                 default = newJBool(true))
  if valid_578967 != nil:
    section.add "prettyPrint", valid_578967
  var valid_578968 = query.getOrDefault("oauth_token")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "oauth_token", valid_578968
  var valid_578969 = query.getOrDefault("$.xgafv")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = newJString("1"))
  if valid_578969 != nil:
    section.add "$.xgafv", valid_578969
  var valid_578970 = query.getOrDefault("alt")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = newJString("json"))
  if valid_578970 != nil:
    section.add "alt", valid_578970
  var valid_578971 = query.getOrDefault("uploadType")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "uploadType", valid_578971
  var valid_578972 = query.getOrDefault("quotaUser")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "quotaUser", valid_578972
  var valid_578973 = query.getOrDefault("callback")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "callback", valid_578973
  var valid_578974 = query.getOrDefault("fields")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "fields", valid_578974
  var valid_578975 = query.getOrDefault("access_token")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "access_token", valid_578975
  var valid_578976 = query.getOrDefault("upload_protocol")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "upload_protocol", valid_578976
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

proc call*(call_578978: Call_AndroiddeviceprovisioningPartnersDevicesClaimAsync_578962;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Claims a batch of devices for a customer asynchronously. Adds the devices
  ## to zero-touch enrollment. To learn more, read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ## 
  let valid = call_578978.validator(path, query, header, formData, body)
  let scheme = call_578978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578978.url(scheme.get, call_578978.host, call_578978.base,
                         call_578978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578978, url, valid)

proc call*(call_578979: Call_AndroiddeviceprovisioningPartnersDevicesClaimAsync_578962;
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
  var path_578980 = newJObject()
  var query_578981 = newJObject()
  var body_578982 = newJObject()
  add(query_578981, "key", newJString(key))
  add(query_578981, "prettyPrint", newJBool(prettyPrint))
  add(query_578981, "oauth_token", newJString(oauthToken))
  add(query_578981, "$.xgafv", newJString(Xgafv))
  add(path_578980, "partnerId", newJString(partnerId))
  add(query_578981, "alt", newJString(alt))
  add(query_578981, "uploadType", newJString(uploadType))
  add(query_578981, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578982 = body
  add(query_578981, "callback", newJString(callback))
  add(query_578981, "fields", newJString(fields))
  add(query_578981, "access_token", newJString(accessToken))
  add(query_578981, "upload_protocol", newJString(uploadProtocol))
  result = call_578979.call(path_578980, query_578981, nil, nil, body_578982)

var androiddeviceprovisioningPartnersDevicesClaimAsync* = Call_AndroiddeviceprovisioningPartnersDevicesClaimAsync_578962(
    name: "androiddeviceprovisioningPartnersDevicesClaimAsync",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:claimAsync",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesClaimAsync_578963,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesClaimAsync_578964,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_578983 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_578985(
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

proc validate_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_578984(
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
  var valid_578986 = path.getOrDefault("partnerId")
  valid_578986 = validateParameter(valid_578986, JString, required = true,
                                 default = nil)
  if valid_578986 != nil:
    section.add "partnerId", valid_578986
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
  var valid_578987 = query.getOrDefault("key")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "key", valid_578987
  var valid_578988 = query.getOrDefault("prettyPrint")
  valid_578988 = validateParameter(valid_578988, JBool, required = false,
                                 default = newJBool(true))
  if valid_578988 != nil:
    section.add "prettyPrint", valid_578988
  var valid_578989 = query.getOrDefault("oauth_token")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "oauth_token", valid_578989
  var valid_578990 = query.getOrDefault("$.xgafv")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = newJString("1"))
  if valid_578990 != nil:
    section.add "$.xgafv", valid_578990
  var valid_578991 = query.getOrDefault("alt")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = newJString("json"))
  if valid_578991 != nil:
    section.add "alt", valid_578991
  var valid_578992 = query.getOrDefault("uploadType")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "uploadType", valid_578992
  var valid_578993 = query.getOrDefault("quotaUser")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "quotaUser", valid_578993
  var valid_578994 = query.getOrDefault("callback")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "callback", valid_578994
  var valid_578995 = query.getOrDefault("fields")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "fields", valid_578995
  var valid_578996 = query.getOrDefault("access_token")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "access_token", valid_578996
  var valid_578997 = query.getOrDefault("upload_protocol")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "upload_protocol", valid_578997
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

proc call*(call_578999: Call_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_578983;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Finds devices by hardware identifiers, such as IMEI.
  ## 
  let valid = call_578999.validator(path, query, header, formData, body)
  let scheme = call_578999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578999.url(scheme.get, call_578999.host, call_578999.base,
                         call_578999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578999, url, valid)

proc call*(call_579000: Call_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_578983;
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
  var path_579001 = newJObject()
  var query_579002 = newJObject()
  var body_579003 = newJObject()
  add(query_579002, "key", newJString(key))
  add(query_579002, "prettyPrint", newJBool(prettyPrint))
  add(query_579002, "oauth_token", newJString(oauthToken))
  add(query_579002, "$.xgafv", newJString(Xgafv))
  add(path_579001, "partnerId", newJString(partnerId))
  add(query_579002, "alt", newJString(alt))
  add(query_579002, "uploadType", newJString(uploadType))
  add(query_579002, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579003 = body
  add(query_579002, "callback", newJString(callback))
  add(query_579002, "fields", newJString(fields))
  add(query_579002, "access_token", newJString(accessToken))
  add(query_579002, "upload_protocol", newJString(uploadProtocol))
  result = call_579000.call(path_579001, query_579002, nil, nil, body_579003)

var androiddeviceprovisioningPartnersDevicesFindByIdentifier* = Call_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_578983(
    name: "androiddeviceprovisioningPartnersDevicesFindByIdentifier",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:findByIdentifier", validator: validate_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_578984,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesFindByIdentifier_578985,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesFindByOwner_579004 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningPartnersDevicesFindByOwner_579006(
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

proc validate_AndroiddeviceprovisioningPartnersDevicesFindByOwner_579005(
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
  var valid_579007 = path.getOrDefault("partnerId")
  valid_579007 = validateParameter(valid_579007, JString, required = true,
                                 default = nil)
  if valid_579007 != nil:
    section.add "partnerId", valid_579007
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
  var valid_579008 = query.getOrDefault("key")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "key", valid_579008
  var valid_579009 = query.getOrDefault("prettyPrint")
  valid_579009 = validateParameter(valid_579009, JBool, required = false,
                                 default = newJBool(true))
  if valid_579009 != nil:
    section.add "prettyPrint", valid_579009
  var valid_579010 = query.getOrDefault("oauth_token")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "oauth_token", valid_579010
  var valid_579011 = query.getOrDefault("$.xgafv")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = newJString("1"))
  if valid_579011 != nil:
    section.add "$.xgafv", valid_579011
  var valid_579012 = query.getOrDefault("alt")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = newJString("json"))
  if valid_579012 != nil:
    section.add "alt", valid_579012
  var valid_579013 = query.getOrDefault("uploadType")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "uploadType", valid_579013
  var valid_579014 = query.getOrDefault("quotaUser")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "quotaUser", valid_579014
  var valid_579015 = query.getOrDefault("callback")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "callback", valid_579015
  var valid_579016 = query.getOrDefault("fields")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "fields", valid_579016
  var valid_579017 = query.getOrDefault("access_token")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "access_token", valid_579017
  var valid_579018 = query.getOrDefault("upload_protocol")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "upload_protocol", valid_579018
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

proc call*(call_579020: Call_AndroiddeviceprovisioningPartnersDevicesFindByOwner_579004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Finds devices claimed for customers. The results only contain devices
  ## registered to the reseller that's identified by the `partnerId` argument.
  ## The customer's devices purchased from other resellers don't appear in the
  ## results.
  ## 
  let valid = call_579020.validator(path, query, header, formData, body)
  let scheme = call_579020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579020.url(scheme.get, call_579020.host, call_579020.base,
                         call_579020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579020, url, valid)

proc call*(call_579021: Call_AndroiddeviceprovisioningPartnersDevicesFindByOwner_579004;
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
  var path_579022 = newJObject()
  var query_579023 = newJObject()
  var body_579024 = newJObject()
  add(query_579023, "key", newJString(key))
  add(query_579023, "prettyPrint", newJBool(prettyPrint))
  add(query_579023, "oauth_token", newJString(oauthToken))
  add(query_579023, "$.xgafv", newJString(Xgafv))
  add(path_579022, "partnerId", newJString(partnerId))
  add(query_579023, "alt", newJString(alt))
  add(query_579023, "uploadType", newJString(uploadType))
  add(query_579023, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579024 = body
  add(query_579023, "callback", newJString(callback))
  add(query_579023, "fields", newJString(fields))
  add(query_579023, "access_token", newJString(accessToken))
  add(query_579023, "upload_protocol", newJString(uploadProtocol))
  result = call_579021.call(path_579022, query_579023, nil, nil, body_579024)

var androiddeviceprovisioningPartnersDevicesFindByOwner* = Call_AndroiddeviceprovisioningPartnersDevicesFindByOwner_579004(
    name: "androiddeviceprovisioningPartnersDevicesFindByOwner",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:findByOwner",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesFindByOwner_579005,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesFindByOwner_579006,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesUnclaim_579025 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningPartnersDevicesUnclaim_579027(protocol: Scheme;
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

proc validate_AndroiddeviceprovisioningPartnersDevicesUnclaim_579026(
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
  var valid_579028 = path.getOrDefault("partnerId")
  valid_579028 = validateParameter(valid_579028, JString, required = true,
                                 default = nil)
  if valid_579028 != nil:
    section.add "partnerId", valid_579028
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
  var valid_579029 = query.getOrDefault("key")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "key", valid_579029
  var valid_579030 = query.getOrDefault("prettyPrint")
  valid_579030 = validateParameter(valid_579030, JBool, required = false,
                                 default = newJBool(true))
  if valid_579030 != nil:
    section.add "prettyPrint", valid_579030
  var valid_579031 = query.getOrDefault("oauth_token")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "oauth_token", valid_579031
  var valid_579032 = query.getOrDefault("$.xgafv")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = newJString("1"))
  if valid_579032 != nil:
    section.add "$.xgafv", valid_579032
  var valid_579033 = query.getOrDefault("alt")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = newJString("json"))
  if valid_579033 != nil:
    section.add "alt", valid_579033
  var valid_579034 = query.getOrDefault("uploadType")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "uploadType", valid_579034
  var valid_579035 = query.getOrDefault("quotaUser")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "quotaUser", valid_579035
  var valid_579036 = query.getOrDefault("callback")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "callback", valid_579036
  var valid_579037 = query.getOrDefault("fields")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "fields", valid_579037
  var valid_579038 = query.getOrDefault("access_token")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "access_token", valid_579038
  var valid_579039 = query.getOrDefault("upload_protocol")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "upload_protocol", valid_579039
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

proc call*(call_579041: Call_AndroiddeviceprovisioningPartnersDevicesUnclaim_579025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unclaims a device from a customer and removes it from zero-touch
  ## enrollment.
  ## 
  let valid = call_579041.validator(path, query, header, formData, body)
  let scheme = call_579041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579041.url(scheme.get, call_579041.host, call_579041.base,
                         call_579041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579041, url, valid)

proc call*(call_579042: Call_AndroiddeviceprovisioningPartnersDevicesUnclaim_579025;
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
  var path_579043 = newJObject()
  var query_579044 = newJObject()
  var body_579045 = newJObject()
  add(query_579044, "key", newJString(key))
  add(query_579044, "prettyPrint", newJBool(prettyPrint))
  add(query_579044, "oauth_token", newJString(oauthToken))
  add(query_579044, "$.xgafv", newJString(Xgafv))
  add(path_579043, "partnerId", newJString(partnerId))
  add(query_579044, "alt", newJString(alt))
  add(query_579044, "uploadType", newJString(uploadType))
  add(query_579044, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579045 = body
  add(query_579044, "callback", newJString(callback))
  add(query_579044, "fields", newJString(fields))
  add(query_579044, "access_token", newJString(accessToken))
  add(query_579044, "upload_protocol", newJString(uploadProtocol))
  result = call_579042.call(path_579043, query_579044, nil, nil, body_579045)

var androiddeviceprovisioningPartnersDevicesUnclaim* = Call_AndroiddeviceprovisioningPartnersDevicesUnclaim_579025(
    name: "androiddeviceprovisioningPartnersDevicesUnclaim",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:unclaim",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesUnclaim_579026,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesUnclaim_579027,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_579046 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_579048(
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

proc validate_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_579047(
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
  var valid_579049 = path.getOrDefault("partnerId")
  valid_579049 = validateParameter(valid_579049, JString, required = true,
                                 default = nil)
  if valid_579049 != nil:
    section.add "partnerId", valid_579049
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
  var valid_579050 = query.getOrDefault("key")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "key", valid_579050
  var valid_579051 = query.getOrDefault("prettyPrint")
  valid_579051 = validateParameter(valid_579051, JBool, required = false,
                                 default = newJBool(true))
  if valid_579051 != nil:
    section.add "prettyPrint", valid_579051
  var valid_579052 = query.getOrDefault("oauth_token")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "oauth_token", valid_579052
  var valid_579053 = query.getOrDefault("$.xgafv")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = newJString("1"))
  if valid_579053 != nil:
    section.add "$.xgafv", valid_579053
  var valid_579054 = query.getOrDefault("alt")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = newJString("json"))
  if valid_579054 != nil:
    section.add "alt", valid_579054
  var valid_579055 = query.getOrDefault("uploadType")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "uploadType", valid_579055
  var valid_579056 = query.getOrDefault("quotaUser")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "quotaUser", valid_579056
  var valid_579057 = query.getOrDefault("callback")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "callback", valid_579057
  var valid_579058 = query.getOrDefault("fields")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "fields", valid_579058
  var valid_579059 = query.getOrDefault("access_token")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "access_token", valid_579059
  var valid_579060 = query.getOrDefault("upload_protocol")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "upload_protocol", valid_579060
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

proc call*(call_579062: Call_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_579046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unclaims a batch of devices for a customer asynchronously. Removes the
  ## devices from zero-touch enrollment. To learn more, read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ## 
  let valid = call_579062.validator(path, query, header, formData, body)
  let scheme = call_579062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579062.url(scheme.get, call_579062.host, call_579062.base,
                         call_579062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579062, url, valid)

proc call*(call_579063: Call_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_579046;
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
  var path_579064 = newJObject()
  var query_579065 = newJObject()
  var body_579066 = newJObject()
  add(query_579065, "key", newJString(key))
  add(query_579065, "prettyPrint", newJBool(prettyPrint))
  add(query_579065, "oauth_token", newJString(oauthToken))
  add(query_579065, "$.xgafv", newJString(Xgafv))
  add(path_579064, "partnerId", newJString(partnerId))
  add(query_579065, "alt", newJString(alt))
  add(query_579065, "uploadType", newJString(uploadType))
  add(query_579065, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579066 = body
  add(query_579065, "callback", newJString(callback))
  add(query_579065, "fields", newJString(fields))
  add(query_579065, "access_token", newJString(accessToken))
  add(query_579065, "upload_protocol", newJString(uploadProtocol))
  result = call_579063.call(path_579064, query_579065, nil, nil, body_579066)

var androiddeviceprovisioningPartnersDevicesUnclaimAsync* = Call_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_579046(
    name: "androiddeviceprovisioningPartnersDevicesUnclaimAsync",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:unclaimAsync",
    validator: validate_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_579047,
    base: "/", url: url_AndroiddeviceprovisioningPartnersDevicesUnclaimAsync_579048,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_579067 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_579069(
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

proc validate_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_579068(
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
  var valid_579070 = path.getOrDefault("partnerId")
  valid_579070 = validateParameter(valid_579070, JString, required = true,
                                 default = nil)
  if valid_579070 != nil:
    section.add "partnerId", valid_579070
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
  var valid_579071 = query.getOrDefault("key")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "key", valid_579071
  var valid_579072 = query.getOrDefault("prettyPrint")
  valid_579072 = validateParameter(valid_579072, JBool, required = false,
                                 default = newJBool(true))
  if valid_579072 != nil:
    section.add "prettyPrint", valid_579072
  var valid_579073 = query.getOrDefault("oauth_token")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "oauth_token", valid_579073
  var valid_579074 = query.getOrDefault("$.xgafv")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = newJString("1"))
  if valid_579074 != nil:
    section.add "$.xgafv", valid_579074
  var valid_579075 = query.getOrDefault("alt")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = newJString("json"))
  if valid_579075 != nil:
    section.add "alt", valid_579075
  var valid_579076 = query.getOrDefault("uploadType")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "uploadType", valid_579076
  var valid_579077 = query.getOrDefault("quotaUser")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "quotaUser", valid_579077
  var valid_579078 = query.getOrDefault("callback")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "callback", valid_579078
  var valid_579079 = query.getOrDefault("fields")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "fields", valid_579079
  var valid_579080 = query.getOrDefault("access_token")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "access_token", valid_579080
  var valid_579081 = query.getOrDefault("upload_protocol")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "upload_protocol", valid_579081
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

proc call*(call_579083: Call_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_579067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the reseller metadata attached to a batch of devices. This method
  ## updates devices asynchronously and returns an `Operation` that can be used
  ## to track progress. Read [Long‑running batch
  ## operations](/zero-touch/guides/how-it-works#operations).
  ## 
  let valid = call_579083.validator(path, query, header, formData, body)
  let scheme = call_579083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579083.url(scheme.get, call_579083.host, call_579083.base,
                         call_579083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579083, url, valid)

proc call*(call_579084: Call_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_579067;
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
  var path_579085 = newJObject()
  var query_579086 = newJObject()
  var body_579087 = newJObject()
  add(query_579086, "key", newJString(key))
  add(query_579086, "prettyPrint", newJBool(prettyPrint))
  add(query_579086, "oauth_token", newJString(oauthToken))
  add(query_579086, "$.xgafv", newJString(Xgafv))
  add(path_579085, "partnerId", newJString(partnerId))
  add(query_579086, "alt", newJString(alt))
  add(query_579086, "uploadType", newJString(uploadType))
  add(query_579086, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579087 = body
  add(query_579086, "callback", newJString(callback))
  add(query_579086, "fields", newJString(fields))
  add(query_579086, "access_token", newJString(accessToken))
  add(query_579086, "upload_protocol", newJString(uploadProtocol))
  result = call_579084.call(path_579085, query_579086, nil, nil, body_579087)

var androiddeviceprovisioningPartnersDevicesUpdateMetadataAsync* = Call_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_579067(
    name: "androiddeviceprovisioningPartnersDevicesUpdateMetadataAsync",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/partners/{partnerId}/devices:updateMetadataAsync", validator: validate_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_579068,
    base: "/",
    url: url_AndroiddeviceprovisioningPartnersDevicesUpdateMetadataAsync_579069,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesGet_579088 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningCustomersDevicesGet_579090(protocol: Scheme;
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

proc validate_AndroiddeviceprovisioningCustomersDevicesGet_579089(path: JsonNode;
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
  var valid_579091 = path.getOrDefault("name")
  valid_579091 = validateParameter(valid_579091, JString, required = true,
                                 default = nil)
  if valid_579091 != nil:
    section.add "name", valid_579091
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
  var valid_579092 = query.getOrDefault("key")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "key", valid_579092
  var valid_579093 = query.getOrDefault("prettyPrint")
  valid_579093 = validateParameter(valid_579093, JBool, required = false,
                                 default = newJBool(true))
  if valid_579093 != nil:
    section.add "prettyPrint", valid_579093
  var valid_579094 = query.getOrDefault("oauth_token")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "oauth_token", valid_579094
  var valid_579095 = query.getOrDefault("$.xgafv")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = newJString("1"))
  if valid_579095 != nil:
    section.add "$.xgafv", valid_579095
  var valid_579096 = query.getOrDefault("alt")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = newJString("json"))
  if valid_579096 != nil:
    section.add "alt", valid_579096
  var valid_579097 = query.getOrDefault("uploadType")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "uploadType", valid_579097
  var valid_579098 = query.getOrDefault("quotaUser")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "quotaUser", valid_579098
  var valid_579099 = query.getOrDefault("callback")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "callback", valid_579099
  var valid_579100 = query.getOrDefault("fields")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "fields", valid_579100
  var valid_579101 = query.getOrDefault("access_token")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "access_token", valid_579101
  var valid_579102 = query.getOrDefault("upload_protocol")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "upload_protocol", valid_579102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579103: Call_AndroiddeviceprovisioningCustomersDevicesGet_579088;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a device.
  ## 
  let valid = call_579103.validator(path, query, header, formData, body)
  let scheme = call_579103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579103.url(scheme.get, call_579103.host, call_579103.base,
                         call_579103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579103, url, valid)

proc call*(call_579104: Call_AndroiddeviceprovisioningCustomersDevicesGet_579088;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## androiddeviceprovisioningCustomersDevicesGet
  ## Gets the details of a device.
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
  ##       : Required. The device to get. An API resource name in the format
  ## `customers/[CUSTOMER_ID]/devices/[DEVICE_ID]`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579105 = newJObject()
  var query_579106 = newJObject()
  add(query_579106, "key", newJString(key))
  add(query_579106, "prettyPrint", newJBool(prettyPrint))
  add(query_579106, "oauth_token", newJString(oauthToken))
  add(query_579106, "$.xgafv", newJString(Xgafv))
  add(query_579106, "alt", newJString(alt))
  add(query_579106, "uploadType", newJString(uploadType))
  add(query_579106, "quotaUser", newJString(quotaUser))
  add(path_579105, "name", newJString(name))
  add(query_579106, "callback", newJString(callback))
  add(query_579106, "fields", newJString(fields))
  add(query_579106, "access_token", newJString(accessToken))
  add(query_579106, "upload_protocol", newJString(uploadProtocol))
  result = call_579104.call(path_579105, query_579106, nil, nil, nil)

var androiddeviceprovisioningCustomersDevicesGet* = Call_AndroiddeviceprovisioningCustomersDevicesGet_579088(
    name: "androiddeviceprovisioningCustomersDevicesGet",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AndroiddeviceprovisioningCustomersDevicesGet_579089,
    base: "/", url: url_AndroiddeviceprovisioningCustomersDevicesGet_579090,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersConfigurationsPatch_579126 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningCustomersConfigurationsPatch_579128(
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

proc validate_AndroiddeviceprovisioningCustomersConfigurationsPatch_579127(
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
  var valid_579129 = path.getOrDefault("name")
  valid_579129 = validateParameter(valid_579129, JString, required = true,
                                 default = nil)
  if valid_579129 != nil:
    section.add "name", valid_579129
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
  var valid_579130 = query.getOrDefault("key")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "key", valid_579130
  var valid_579131 = query.getOrDefault("prettyPrint")
  valid_579131 = validateParameter(valid_579131, JBool, required = false,
                                 default = newJBool(true))
  if valid_579131 != nil:
    section.add "prettyPrint", valid_579131
  var valid_579132 = query.getOrDefault("oauth_token")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "oauth_token", valid_579132
  var valid_579133 = query.getOrDefault("$.xgafv")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = newJString("1"))
  if valid_579133 != nil:
    section.add "$.xgafv", valid_579133
  var valid_579134 = query.getOrDefault("alt")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = newJString("json"))
  if valid_579134 != nil:
    section.add "alt", valid_579134
  var valid_579135 = query.getOrDefault("uploadType")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "uploadType", valid_579135
  var valid_579136 = query.getOrDefault("quotaUser")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "quotaUser", valid_579136
  var valid_579137 = query.getOrDefault("updateMask")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "updateMask", valid_579137
  var valid_579138 = query.getOrDefault("callback")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "callback", valid_579138
  var valid_579139 = query.getOrDefault("fields")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "fields", valid_579139
  var valid_579140 = query.getOrDefault("access_token")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "access_token", valid_579140
  var valid_579141 = query.getOrDefault("upload_protocol")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "upload_protocol", valid_579141
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

proc call*(call_579143: Call_AndroiddeviceprovisioningCustomersConfigurationsPatch_579126;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a configuration's field values.
  ## 
  let valid = call_579143.validator(path, query, header, formData, body)
  let scheme = call_579143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579143.url(scheme.get, call_579143.host, call_579143.base,
                         call_579143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579143, url, valid)

proc call*(call_579144: Call_AndroiddeviceprovisioningCustomersConfigurationsPatch_579126;
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
  var path_579145 = newJObject()
  var query_579146 = newJObject()
  var body_579147 = newJObject()
  add(query_579146, "key", newJString(key))
  add(query_579146, "prettyPrint", newJBool(prettyPrint))
  add(query_579146, "oauth_token", newJString(oauthToken))
  add(query_579146, "$.xgafv", newJString(Xgafv))
  add(query_579146, "alt", newJString(alt))
  add(query_579146, "uploadType", newJString(uploadType))
  add(query_579146, "quotaUser", newJString(quotaUser))
  add(path_579145, "name", newJString(name))
  add(query_579146, "updateMask", newJString(updateMask))
  if body != nil:
    body_579147 = body
  add(query_579146, "callback", newJString(callback))
  add(query_579146, "fields", newJString(fields))
  add(query_579146, "access_token", newJString(accessToken))
  add(query_579146, "upload_protocol", newJString(uploadProtocol))
  result = call_579144.call(path_579145, query_579146, nil, nil, body_579147)

var androiddeviceprovisioningCustomersConfigurationsPatch* = Call_AndroiddeviceprovisioningCustomersConfigurationsPatch_579126(
    name: "androiddeviceprovisioningCustomersConfigurationsPatch",
    meth: HttpMethod.HttpPatch, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AndroiddeviceprovisioningCustomersConfigurationsPatch_579127,
    base: "/", url: url_AndroiddeviceprovisioningCustomersConfigurationsPatch_579128,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersConfigurationsDelete_579107 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningCustomersConfigurationsDelete_579109(
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

proc validate_AndroiddeviceprovisioningCustomersConfigurationsDelete_579108(
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
  var valid_579110 = path.getOrDefault("name")
  valid_579110 = validateParameter(valid_579110, JString, required = true,
                                 default = nil)
  if valid_579110 != nil:
    section.add "name", valid_579110
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
  var valid_579111 = query.getOrDefault("key")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "key", valid_579111
  var valid_579112 = query.getOrDefault("prettyPrint")
  valid_579112 = validateParameter(valid_579112, JBool, required = false,
                                 default = newJBool(true))
  if valid_579112 != nil:
    section.add "prettyPrint", valid_579112
  var valid_579113 = query.getOrDefault("oauth_token")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "oauth_token", valid_579113
  var valid_579114 = query.getOrDefault("$.xgafv")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = newJString("1"))
  if valid_579114 != nil:
    section.add "$.xgafv", valid_579114
  var valid_579115 = query.getOrDefault("alt")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = newJString("json"))
  if valid_579115 != nil:
    section.add "alt", valid_579115
  var valid_579116 = query.getOrDefault("uploadType")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "uploadType", valid_579116
  var valid_579117 = query.getOrDefault("quotaUser")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "quotaUser", valid_579117
  var valid_579118 = query.getOrDefault("callback")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "callback", valid_579118
  var valid_579119 = query.getOrDefault("fields")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "fields", valid_579119
  var valid_579120 = query.getOrDefault("access_token")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "access_token", valid_579120
  var valid_579121 = query.getOrDefault("upload_protocol")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "upload_protocol", valid_579121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579122: Call_AndroiddeviceprovisioningCustomersConfigurationsDelete_579107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an unused configuration. The API call fails if the customer has
  ## devices with the configuration applied.
  ## 
  let valid = call_579122.validator(path, query, header, formData, body)
  let scheme = call_579122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579122.url(scheme.get, call_579122.host, call_579122.base,
                         call_579122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579122, url, valid)

proc call*(call_579123: Call_AndroiddeviceprovisioningCustomersConfigurationsDelete_579107;
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
  var path_579124 = newJObject()
  var query_579125 = newJObject()
  add(query_579125, "key", newJString(key))
  add(query_579125, "prettyPrint", newJBool(prettyPrint))
  add(query_579125, "oauth_token", newJString(oauthToken))
  add(query_579125, "$.xgafv", newJString(Xgafv))
  add(query_579125, "alt", newJString(alt))
  add(query_579125, "uploadType", newJString(uploadType))
  add(query_579125, "quotaUser", newJString(quotaUser))
  add(path_579124, "name", newJString(name))
  add(query_579125, "callback", newJString(callback))
  add(query_579125, "fields", newJString(fields))
  add(query_579125, "access_token", newJString(accessToken))
  add(query_579125, "upload_protocol", newJString(uploadProtocol))
  result = call_579123.call(path_579124, query_579125, nil, nil, nil)

var androiddeviceprovisioningCustomersConfigurationsDelete* = Call_AndroiddeviceprovisioningCustomersConfigurationsDelete_579107(
    name: "androiddeviceprovisioningCustomersConfigurationsDelete",
    meth: HttpMethod.HttpDelete, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AndroiddeviceprovisioningCustomersConfigurationsDelete_579108,
    base: "/", url: url_AndroiddeviceprovisioningCustomersConfigurationsDelete_579109,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersConfigurationsCreate_579167 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningCustomersConfigurationsCreate_579169(
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

proc validate_AndroiddeviceprovisioningCustomersConfigurationsCreate_579168(
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
  var valid_579170 = path.getOrDefault("parent")
  valid_579170 = validateParameter(valid_579170, JString, required = true,
                                 default = nil)
  if valid_579170 != nil:
    section.add "parent", valid_579170
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
  var valid_579171 = query.getOrDefault("key")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "key", valid_579171
  var valid_579172 = query.getOrDefault("prettyPrint")
  valid_579172 = validateParameter(valid_579172, JBool, required = false,
                                 default = newJBool(true))
  if valid_579172 != nil:
    section.add "prettyPrint", valid_579172
  var valid_579173 = query.getOrDefault("oauth_token")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "oauth_token", valid_579173
  var valid_579174 = query.getOrDefault("$.xgafv")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = newJString("1"))
  if valid_579174 != nil:
    section.add "$.xgafv", valid_579174
  var valid_579175 = query.getOrDefault("alt")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = newJString("json"))
  if valid_579175 != nil:
    section.add "alt", valid_579175
  var valid_579176 = query.getOrDefault("uploadType")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "uploadType", valid_579176
  var valid_579177 = query.getOrDefault("quotaUser")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "quotaUser", valid_579177
  var valid_579178 = query.getOrDefault("callback")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "callback", valid_579178
  var valid_579179 = query.getOrDefault("fields")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "fields", valid_579179
  var valid_579180 = query.getOrDefault("access_token")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "access_token", valid_579180
  var valid_579181 = query.getOrDefault("upload_protocol")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "upload_protocol", valid_579181
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

proc call*(call_579183: Call_AndroiddeviceprovisioningCustomersConfigurationsCreate_579167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new configuration. Once created, a customer can apply the
  ## configuration to devices.
  ## 
  let valid = call_579183.validator(path, query, header, formData, body)
  let scheme = call_579183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579183.url(scheme.get, call_579183.host, call_579183.base,
                         call_579183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579183, url, valid)

proc call*(call_579184: Call_AndroiddeviceprovisioningCustomersConfigurationsCreate_579167;
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
  var path_579185 = newJObject()
  var query_579186 = newJObject()
  var body_579187 = newJObject()
  add(query_579186, "key", newJString(key))
  add(query_579186, "prettyPrint", newJBool(prettyPrint))
  add(query_579186, "oauth_token", newJString(oauthToken))
  add(query_579186, "$.xgafv", newJString(Xgafv))
  add(query_579186, "alt", newJString(alt))
  add(query_579186, "uploadType", newJString(uploadType))
  add(query_579186, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579187 = body
  add(query_579186, "callback", newJString(callback))
  add(path_579185, "parent", newJString(parent))
  add(query_579186, "fields", newJString(fields))
  add(query_579186, "access_token", newJString(accessToken))
  add(query_579186, "upload_protocol", newJString(uploadProtocol))
  result = call_579184.call(path_579185, query_579186, nil, nil, body_579187)

var androiddeviceprovisioningCustomersConfigurationsCreate* = Call_AndroiddeviceprovisioningCustomersConfigurationsCreate_579167(
    name: "androiddeviceprovisioningCustomersConfigurationsCreate",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/configurations",
    validator: validate_AndroiddeviceprovisioningCustomersConfigurationsCreate_579168,
    base: "/", url: url_AndroiddeviceprovisioningCustomersConfigurationsCreate_579169,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersConfigurationsList_579148 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningCustomersConfigurationsList_579150(
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

proc validate_AndroiddeviceprovisioningCustomersConfigurationsList_579149(
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
  var valid_579151 = path.getOrDefault("parent")
  valid_579151 = validateParameter(valid_579151, JString, required = true,
                                 default = nil)
  if valid_579151 != nil:
    section.add "parent", valid_579151
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
  var valid_579152 = query.getOrDefault("key")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "key", valid_579152
  var valid_579153 = query.getOrDefault("prettyPrint")
  valid_579153 = validateParameter(valid_579153, JBool, required = false,
                                 default = newJBool(true))
  if valid_579153 != nil:
    section.add "prettyPrint", valid_579153
  var valid_579154 = query.getOrDefault("oauth_token")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "oauth_token", valid_579154
  var valid_579155 = query.getOrDefault("$.xgafv")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = newJString("1"))
  if valid_579155 != nil:
    section.add "$.xgafv", valid_579155
  var valid_579156 = query.getOrDefault("alt")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = newJString("json"))
  if valid_579156 != nil:
    section.add "alt", valid_579156
  var valid_579157 = query.getOrDefault("uploadType")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "uploadType", valid_579157
  var valid_579158 = query.getOrDefault("quotaUser")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "quotaUser", valid_579158
  var valid_579159 = query.getOrDefault("callback")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "callback", valid_579159
  var valid_579160 = query.getOrDefault("fields")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "fields", valid_579160
  var valid_579161 = query.getOrDefault("access_token")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "access_token", valid_579161
  var valid_579162 = query.getOrDefault("upload_protocol")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "upload_protocol", valid_579162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579163: Call_AndroiddeviceprovisioningCustomersConfigurationsList_579148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a customer's configurations.
  ## 
  let valid = call_579163.validator(path, query, header, formData, body)
  let scheme = call_579163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579163.url(scheme.get, call_579163.host, call_579163.base,
                         call_579163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579163, url, valid)

proc call*(call_579164: Call_AndroiddeviceprovisioningCustomersConfigurationsList_579148;
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
  var path_579165 = newJObject()
  var query_579166 = newJObject()
  add(query_579166, "key", newJString(key))
  add(query_579166, "prettyPrint", newJBool(prettyPrint))
  add(query_579166, "oauth_token", newJString(oauthToken))
  add(query_579166, "$.xgafv", newJString(Xgafv))
  add(query_579166, "alt", newJString(alt))
  add(query_579166, "uploadType", newJString(uploadType))
  add(query_579166, "quotaUser", newJString(quotaUser))
  add(query_579166, "callback", newJString(callback))
  add(path_579165, "parent", newJString(parent))
  add(query_579166, "fields", newJString(fields))
  add(query_579166, "access_token", newJString(accessToken))
  add(query_579166, "upload_protocol", newJString(uploadProtocol))
  result = call_579164.call(path_579165, query_579166, nil, nil, nil)

var androiddeviceprovisioningCustomersConfigurationsList* = Call_AndroiddeviceprovisioningCustomersConfigurationsList_579148(
    name: "androiddeviceprovisioningCustomersConfigurationsList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/configurations",
    validator: validate_AndroiddeviceprovisioningCustomersConfigurationsList_579149,
    base: "/", url: url_AndroiddeviceprovisioningCustomersConfigurationsList_579150,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersCustomersCreate_579209 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningPartnersCustomersCreate_579211(
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

proc validate_AndroiddeviceprovisioningPartnersCustomersCreate_579210(
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
  var valid_579212 = path.getOrDefault("parent")
  valid_579212 = validateParameter(valid_579212, JString, required = true,
                                 default = nil)
  if valid_579212 != nil:
    section.add "parent", valid_579212
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
  var valid_579213 = query.getOrDefault("key")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "key", valid_579213
  var valid_579214 = query.getOrDefault("prettyPrint")
  valid_579214 = validateParameter(valid_579214, JBool, required = false,
                                 default = newJBool(true))
  if valid_579214 != nil:
    section.add "prettyPrint", valid_579214
  var valid_579215 = query.getOrDefault("oauth_token")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "oauth_token", valid_579215
  var valid_579216 = query.getOrDefault("$.xgafv")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = newJString("1"))
  if valid_579216 != nil:
    section.add "$.xgafv", valid_579216
  var valid_579217 = query.getOrDefault("alt")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = newJString("json"))
  if valid_579217 != nil:
    section.add "alt", valid_579217
  var valid_579218 = query.getOrDefault("uploadType")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "uploadType", valid_579218
  var valid_579219 = query.getOrDefault("quotaUser")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "quotaUser", valid_579219
  var valid_579220 = query.getOrDefault("callback")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "callback", valid_579220
  var valid_579221 = query.getOrDefault("fields")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "fields", valid_579221
  var valid_579222 = query.getOrDefault("access_token")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "access_token", valid_579222
  var valid_579223 = query.getOrDefault("upload_protocol")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "upload_protocol", valid_579223
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

proc call*(call_579225: Call_AndroiddeviceprovisioningPartnersCustomersCreate_579209;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a customer for zero-touch enrollment. After the method returns
  ## successfully, admin and owner roles can manage devices and EMM configs
  ## by calling API methods or using their zero-touch enrollment portal.
  ## The customer receives an email that welcomes them to zero-touch enrollment
  ## and explains how to sign into the portal.
  ## 
  let valid = call_579225.validator(path, query, header, formData, body)
  let scheme = call_579225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579225.url(scheme.get, call_579225.host, call_579225.base,
                         call_579225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579225, url, valid)

proc call*(call_579226: Call_AndroiddeviceprovisioningPartnersCustomersCreate_579209;
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
  var path_579227 = newJObject()
  var query_579228 = newJObject()
  var body_579229 = newJObject()
  add(query_579228, "key", newJString(key))
  add(query_579228, "prettyPrint", newJBool(prettyPrint))
  add(query_579228, "oauth_token", newJString(oauthToken))
  add(query_579228, "$.xgafv", newJString(Xgafv))
  add(query_579228, "alt", newJString(alt))
  add(query_579228, "uploadType", newJString(uploadType))
  add(query_579228, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579229 = body
  add(query_579228, "callback", newJString(callback))
  add(path_579227, "parent", newJString(parent))
  add(query_579228, "fields", newJString(fields))
  add(query_579228, "access_token", newJString(accessToken))
  add(query_579228, "upload_protocol", newJString(uploadProtocol))
  result = call_579226.call(path_579227, query_579228, nil, nil, body_579229)

var androiddeviceprovisioningPartnersCustomersCreate* = Call_AndroiddeviceprovisioningPartnersCustomersCreate_579209(
    name: "androiddeviceprovisioningPartnersCustomersCreate",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/customers",
    validator: validate_AndroiddeviceprovisioningPartnersCustomersCreate_579210,
    base: "/", url: url_AndroiddeviceprovisioningPartnersCustomersCreate_579211,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersVendorsCustomersList_579188 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningPartnersVendorsCustomersList_579190(
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

proc validate_AndroiddeviceprovisioningPartnersVendorsCustomersList_579189(
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
  var valid_579191 = path.getOrDefault("parent")
  valid_579191 = validateParameter(valid_579191, JString, required = true,
                                 default = nil)
  if valid_579191 != nil:
    section.add "parent", valid_579191
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
  var valid_579192 = query.getOrDefault("key")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "key", valid_579192
  var valid_579193 = query.getOrDefault("prettyPrint")
  valid_579193 = validateParameter(valid_579193, JBool, required = false,
                                 default = newJBool(true))
  if valid_579193 != nil:
    section.add "prettyPrint", valid_579193
  var valid_579194 = query.getOrDefault("oauth_token")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "oauth_token", valid_579194
  var valid_579195 = query.getOrDefault("$.xgafv")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = newJString("1"))
  if valid_579195 != nil:
    section.add "$.xgafv", valid_579195
  var valid_579196 = query.getOrDefault("pageSize")
  valid_579196 = validateParameter(valid_579196, JInt, required = false, default = nil)
  if valid_579196 != nil:
    section.add "pageSize", valid_579196
  var valid_579197 = query.getOrDefault("alt")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = newJString("json"))
  if valid_579197 != nil:
    section.add "alt", valid_579197
  var valid_579198 = query.getOrDefault("uploadType")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "uploadType", valid_579198
  var valid_579199 = query.getOrDefault("quotaUser")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "quotaUser", valid_579199
  var valid_579200 = query.getOrDefault("pageToken")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "pageToken", valid_579200
  var valid_579201 = query.getOrDefault("callback")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "callback", valid_579201
  var valid_579202 = query.getOrDefault("fields")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "fields", valid_579202
  var valid_579203 = query.getOrDefault("access_token")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "access_token", valid_579203
  var valid_579204 = query.getOrDefault("upload_protocol")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "upload_protocol", valid_579204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579205: Call_AndroiddeviceprovisioningPartnersVendorsCustomersList_579188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the customers of the vendor.
  ## 
  let valid = call_579205.validator(path, query, header, formData, body)
  let scheme = call_579205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579205.url(scheme.get, call_579205.host, call_579205.base,
                         call_579205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579205, url, valid)

proc call*(call_579206: Call_AndroiddeviceprovisioningPartnersVendorsCustomersList_579188;
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
  var path_579207 = newJObject()
  var query_579208 = newJObject()
  add(query_579208, "key", newJString(key))
  add(query_579208, "prettyPrint", newJBool(prettyPrint))
  add(query_579208, "oauth_token", newJString(oauthToken))
  add(query_579208, "$.xgafv", newJString(Xgafv))
  add(query_579208, "pageSize", newJInt(pageSize))
  add(query_579208, "alt", newJString(alt))
  add(query_579208, "uploadType", newJString(uploadType))
  add(query_579208, "quotaUser", newJString(quotaUser))
  add(query_579208, "pageToken", newJString(pageToken))
  add(query_579208, "callback", newJString(callback))
  add(path_579207, "parent", newJString(parent))
  add(query_579208, "fields", newJString(fields))
  add(query_579208, "access_token", newJString(accessToken))
  add(query_579208, "upload_protocol", newJString(uploadProtocol))
  result = call_579206.call(path_579207, query_579208, nil, nil, nil)

var androiddeviceprovisioningPartnersVendorsCustomersList* = Call_AndroiddeviceprovisioningPartnersVendorsCustomersList_579188(
    name: "androiddeviceprovisioningPartnersVendorsCustomersList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/customers",
    validator: validate_AndroiddeviceprovisioningPartnersVendorsCustomersList_579189,
    base: "/", url: url_AndroiddeviceprovisioningPartnersVendorsCustomersList_579190,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesList_579230 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningCustomersDevicesList_579232(protocol: Scheme;
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

proc validate_AndroiddeviceprovisioningCustomersDevicesList_579231(
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
  var valid_579233 = path.getOrDefault("parent")
  valid_579233 = validateParameter(valid_579233, JString, required = true,
                                 default = nil)
  if valid_579233 != nil:
    section.add "parent", valid_579233
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
  var valid_579234 = query.getOrDefault("key")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "key", valid_579234
  var valid_579235 = query.getOrDefault("prettyPrint")
  valid_579235 = validateParameter(valid_579235, JBool, required = false,
                                 default = newJBool(true))
  if valid_579235 != nil:
    section.add "prettyPrint", valid_579235
  var valid_579236 = query.getOrDefault("oauth_token")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "oauth_token", valid_579236
  var valid_579237 = query.getOrDefault("$.xgafv")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = newJString("1"))
  if valid_579237 != nil:
    section.add "$.xgafv", valid_579237
  var valid_579238 = query.getOrDefault("pageSize")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "pageSize", valid_579238
  var valid_579239 = query.getOrDefault("alt")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = newJString("json"))
  if valid_579239 != nil:
    section.add "alt", valid_579239
  var valid_579240 = query.getOrDefault("uploadType")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "uploadType", valid_579240
  var valid_579241 = query.getOrDefault("quotaUser")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "quotaUser", valid_579241
  var valid_579242 = query.getOrDefault("pageToken")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "pageToken", valid_579242
  var valid_579243 = query.getOrDefault("callback")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "callback", valid_579243
  var valid_579244 = query.getOrDefault("fields")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "fields", valid_579244
  var valid_579245 = query.getOrDefault("access_token")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "access_token", valid_579245
  var valid_579246 = query.getOrDefault("upload_protocol")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "upload_protocol", valid_579246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579247: Call_AndroiddeviceprovisioningCustomersDevicesList_579230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists a customer's devices.
  ## 
  let valid = call_579247.validator(path, query, header, formData, body)
  let scheme = call_579247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579247.url(scheme.get, call_579247.host, call_579247.base,
                         call_579247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579247, url, valid)

proc call*(call_579248: Call_AndroiddeviceprovisioningCustomersDevicesList_579230;
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
  var path_579249 = newJObject()
  var query_579250 = newJObject()
  add(query_579250, "key", newJString(key))
  add(query_579250, "prettyPrint", newJBool(prettyPrint))
  add(query_579250, "oauth_token", newJString(oauthToken))
  add(query_579250, "$.xgafv", newJString(Xgafv))
  add(query_579250, "pageSize", newJString(pageSize))
  add(query_579250, "alt", newJString(alt))
  add(query_579250, "uploadType", newJString(uploadType))
  add(query_579250, "quotaUser", newJString(quotaUser))
  add(query_579250, "pageToken", newJString(pageToken))
  add(query_579250, "callback", newJString(callback))
  add(path_579249, "parent", newJString(parent))
  add(query_579250, "fields", newJString(fields))
  add(query_579250, "access_token", newJString(accessToken))
  add(query_579250, "upload_protocol", newJString(uploadProtocol))
  result = call_579248.call(path_579249, query_579250, nil, nil, nil)

var androiddeviceprovisioningCustomersDevicesList* = Call_AndroiddeviceprovisioningCustomersDevicesList_579230(
    name: "androiddeviceprovisioningCustomersDevicesList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/devices",
    validator: validate_AndroiddeviceprovisioningCustomersDevicesList_579231,
    base: "/", url: url_AndroiddeviceprovisioningCustomersDevicesList_579232,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_579251 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_579253(
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

proc validate_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_579252(
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
  var valid_579254 = path.getOrDefault("parent")
  valid_579254 = validateParameter(valid_579254, JString, required = true,
                                 default = nil)
  if valid_579254 != nil:
    section.add "parent", valid_579254
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
  var valid_579255 = query.getOrDefault("key")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "key", valid_579255
  var valid_579256 = query.getOrDefault("prettyPrint")
  valid_579256 = validateParameter(valid_579256, JBool, required = false,
                                 default = newJBool(true))
  if valid_579256 != nil:
    section.add "prettyPrint", valid_579256
  var valid_579257 = query.getOrDefault("oauth_token")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "oauth_token", valid_579257
  var valid_579258 = query.getOrDefault("$.xgafv")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = newJString("1"))
  if valid_579258 != nil:
    section.add "$.xgafv", valid_579258
  var valid_579259 = query.getOrDefault("alt")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = newJString("json"))
  if valid_579259 != nil:
    section.add "alt", valid_579259
  var valid_579260 = query.getOrDefault("uploadType")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "uploadType", valid_579260
  var valid_579261 = query.getOrDefault("quotaUser")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "quotaUser", valid_579261
  var valid_579262 = query.getOrDefault("callback")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "callback", valid_579262
  var valid_579263 = query.getOrDefault("fields")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "fields", valid_579263
  var valid_579264 = query.getOrDefault("access_token")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "access_token", valid_579264
  var valid_579265 = query.getOrDefault("upload_protocol")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "upload_protocol", valid_579265
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

proc call*(call_579267: Call_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_579251;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Applies a Configuration to the device to register the device for zero-touch
  ## enrollment. After applying a configuration to a device, the device
  ## automatically provisions itself on first boot, or next factory reset.
  ## 
  let valid = call_579267.validator(path, query, header, formData, body)
  let scheme = call_579267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579267.url(scheme.get, call_579267.host, call_579267.base,
                         call_579267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579267, url, valid)

proc call*(call_579268: Call_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_579251;
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
  var path_579269 = newJObject()
  var query_579270 = newJObject()
  var body_579271 = newJObject()
  add(query_579270, "key", newJString(key))
  add(query_579270, "prettyPrint", newJBool(prettyPrint))
  add(query_579270, "oauth_token", newJString(oauthToken))
  add(query_579270, "$.xgafv", newJString(Xgafv))
  add(query_579270, "alt", newJString(alt))
  add(query_579270, "uploadType", newJString(uploadType))
  add(query_579270, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579271 = body
  add(query_579270, "callback", newJString(callback))
  add(path_579269, "parent", newJString(parent))
  add(query_579270, "fields", newJString(fields))
  add(query_579270, "access_token", newJString(accessToken))
  add(query_579270, "upload_protocol", newJString(uploadProtocol))
  result = call_579268.call(path_579269, query_579270, nil, nil, body_579271)

var androiddeviceprovisioningCustomersDevicesApplyConfiguration* = Call_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_579251(
    name: "androiddeviceprovisioningCustomersDevicesApplyConfiguration",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/devices:applyConfiguration", validator: validate_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_579252,
    base: "/",
    url: url_AndroiddeviceprovisioningCustomersDevicesApplyConfiguration_579253,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_579272 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_579274(
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

proc validate_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_579273(
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
  var valid_579275 = path.getOrDefault("parent")
  valid_579275 = validateParameter(valid_579275, JString, required = true,
                                 default = nil)
  if valid_579275 != nil:
    section.add "parent", valid_579275
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
  var valid_579276 = query.getOrDefault("key")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "key", valid_579276
  var valid_579277 = query.getOrDefault("prettyPrint")
  valid_579277 = validateParameter(valid_579277, JBool, required = false,
                                 default = newJBool(true))
  if valid_579277 != nil:
    section.add "prettyPrint", valid_579277
  var valid_579278 = query.getOrDefault("oauth_token")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "oauth_token", valid_579278
  var valid_579279 = query.getOrDefault("$.xgafv")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = newJString("1"))
  if valid_579279 != nil:
    section.add "$.xgafv", valid_579279
  var valid_579280 = query.getOrDefault("alt")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = newJString("json"))
  if valid_579280 != nil:
    section.add "alt", valid_579280
  var valid_579281 = query.getOrDefault("uploadType")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "uploadType", valid_579281
  var valid_579282 = query.getOrDefault("quotaUser")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "quotaUser", valid_579282
  var valid_579283 = query.getOrDefault("callback")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "callback", valid_579283
  var valid_579284 = query.getOrDefault("fields")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "fields", valid_579284
  var valid_579285 = query.getOrDefault("access_token")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = nil)
  if valid_579285 != nil:
    section.add "access_token", valid_579285
  var valid_579286 = query.getOrDefault("upload_protocol")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "upload_protocol", valid_579286
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

proc call*(call_579288: Call_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_579272;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a configuration from device.
  ## 
  let valid = call_579288.validator(path, query, header, formData, body)
  let scheme = call_579288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579288.url(scheme.get, call_579288.host, call_579288.base,
                         call_579288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579288, url, valid)

proc call*(call_579289: Call_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_579272;
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
  var path_579290 = newJObject()
  var query_579291 = newJObject()
  var body_579292 = newJObject()
  add(query_579291, "key", newJString(key))
  add(query_579291, "prettyPrint", newJBool(prettyPrint))
  add(query_579291, "oauth_token", newJString(oauthToken))
  add(query_579291, "$.xgafv", newJString(Xgafv))
  add(query_579291, "alt", newJString(alt))
  add(query_579291, "uploadType", newJString(uploadType))
  add(query_579291, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579292 = body
  add(query_579291, "callback", newJString(callback))
  add(path_579290, "parent", newJString(parent))
  add(query_579291, "fields", newJString(fields))
  add(query_579291, "access_token", newJString(accessToken))
  add(query_579291, "upload_protocol", newJString(uploadProtocol))
  result = call_579289.call(path_579290, query_579291, nil, nil, body_579292)

var androiddeviceprovisioningCustomersDevicesRemoveConfiguration* = Call_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_579272(
    name: "androiddeviceprovisioningCustomersDevicesRemoveConfiguration",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/devices:removeConfiguration", validator: validate_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_579273,
    base: "/",
    url: url_AndroiddeviceprovisioningCustomersDevicesRemoveConfiguration_579274,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDevicesUnclaim_579293 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningCustomersDevicesUnclaim_579295(
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

proc validate_AndroiddeviceprovisioningCustomersDevicesUnclaim_579294(
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
  var valid_579296 = path.getOrDefault("parent")
  valid_579296 = validateParameter(valid_579296, JString, required = true,
                                 default = nil)
  if valid_579296 != nil:
    section.add "parent", valid_579296
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
  var valid_579297 = query.getOrDefault("key")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "key", valid_579297
  var valid_579298 = query.getOrDefault("prettyPrint")
  valid_579298 = validateParameter(valid_579298, JBool, required = false,
                                 default = newJBool(true))
  if valid_579298 != nil:
    section.add "prettyPrint", valid_579298
  var valid_579299 = query.getOrDefault("oauth_token")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "oauth_token", valid_579299
  var valid_579300 = query.getOrDefault("$.xgafv")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = newJString("1"))
  if valid_579300 != nil:
    section.add "$.xgafv", valid_579300
  var valid_579301 = query.getOrDefault("alt")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = newJString("json"))
  if valid_579301 != nil:
    section.add "alt", valid_579301
  var valid_579302 = query.getOrDefault("uploadType")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "uploadType", valid_579302
  var valid_579303 = query.getOrDefault("quotaUser")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "quotaUser", valid_579303
  var valid_579304 = query.getOrDefault("callback")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "callback", valid_579304
  var valid_579305 = query.getOrDefault("fields")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "fields", valid_579305
  var valid_579306 = query.getOrDefault("access_token")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "access_token", valid_579306
  var valid_579307 = query.getOrDefault("upload_protocol")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = nil)
  if valid_579307 != nil:
    section.add "upload_protocol", valid_579307
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

proc call*(call_579309: Call_AndroiddeviceprovisioningCustomersDevicesUnclaim_579293;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unclaims a device from a customer and removes it from zero-touch
  ## enrollment.
  ## 
  ## After removing a device, a customer must contact their reseller to register
  ## the device into zero-touch enrollment again.
  ## 
  let valid = call_579309.validator(path, query, header, formData, body)
  let scheme = call_579309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579309.url(scheme.get, call_579309.host, call_579309.base,
                         call_579309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579309, url, valid)

proc call*(call_579310: Call_AndroiddeviceprovisioningCustomersDevicesUnclaim_579293;
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
  var path_579311 = newJObject()
  var query_579312 = newJObject()
  var body_579313 = newJObject()
  add(query_579312, "key", newJString(key))
  add(query_579312, "prettyPrint", newJBool(prettyPrint))
  add(query_579312, "oauth_token", newJString(oauthToken))
  add(query_579312, "$.xgafv", newJString(Xgafv))
  add(query_579312, "alt", newJString(alt))
  add(query_579312, "uploadType", newJString(uploadType))
  add(query_579312, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579313 = body
  add(query_579312, "callback", newJString(callback))
  add(path_579311, "parent", newJString(parent))
  add(query_579312, "fields", newJString(fields))
  add(query_579312, "access_token", newJString(accessToken))
  add(query_579312, "upload_protocol", newJString(uploadProtocol))
  result = call_579310.call(path_579311, query_579312, nil, nil, body_579313)

var androiddeviceprovisioningCustomersDevicesUnclaim* = Call_AndroiddeviceprovisioningCustomersDevicesUnclaim_579293(
    name: "androiddeviceprovisioningCustomersDevicesUnclaim",
    meth: HttpMethod.HttpPost, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/devices:unclaim",
    validator: validate_AndroiddeviceprovisioningCustomersDevicesUnclaim_579294,
    base: "/", url: url_AndroiddeviceprovisioningCustomersDevicesUnclaim_579295,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningCustomersDpcsList_579314 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningCustomersDpcsList_579316(protocol: Scheme;
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

proc validate_AndroiddeviceprovisioningCustomersDpcsList_579315(path: JsonNode;
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
  var valid_579317 = path.getOrDefault("parent")
  valid_579317 = validateParameter(valid_579317, JString, required = true,
                                 default = nil)
  if valid_579317 != nil:
    section.add "parent", valid_579317
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
  var valid_579318 = query.getOrDefault("key")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "key", valid_579318
  var valid_579319 = query.getOrDefault("prettyPrint")
  valid_579319 = validateParameter(valid_579319, JBool, required = false,
                                 default = newJBool(true))
  if valid_579319 != nil:
    section.add "prettyPrint", valid_579319
  var valid_579320 = query.getOrDefault("oauth_token")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "oauth_token", valid_579320
  var valid_579321 = query.getOrDefault("$.xgafv")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = newJString("1"))
  if valid_579321 != nil:
    section.add "$.xgafv", valid_579321
  var valid_579322 = query.getOrDefault("alt")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = newJString("json"))
  if valid_579322 != nil:
    section.add "alt", valid_579322
  var valid_579323 = query.getOrDefault("uploadType")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "uploadType", valid_579323
  var valid_579324 = query.getOrDefault("quotaUser")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "quotaUser", valid_579324
  var valid_579325 = query.getOrDefault("callback")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "callback", valid_579325
  var valid_579326 = query.getOrDefault("fields")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "fields", valid_579326
  var valid_579327 = query.getOrDefault("access_token")
  valid_579327 = validateParameter(valid_579327, JString, required = false,
                                 default = nil)
  if valid_579327 != nil:
    section.add "access_token", valid_579327
  var valid_579328 = query.getOrDefault("upload_protocol")
  valid_579328 = validateParameter(valid_579328, JString, required = false,
                                 default = nil)
  if valid_579328 != nil:
    section.add "upload_protocol", valid_579328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579329: Call_AndroiddeviceprovisioningCustomersDpcsList_579314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the DPCs (device policy controllers) that support zero-touch
  ## enrollment.
  ## 
  let valid = call_579329.validator(path, query, header, formData, body)
  let scheme = call_579329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579329.url(scheme.get, call_579329.host, call_579329.base,
                         call_579329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579329, url, valid)

proc call*(call_579330: Call_AndroiddeviceprovisioningCustomersDpcsList_579314;
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
  var path_579331 = newJObject()
  var query_579332 = newJObject()
  add(query_579332, "key", newJString(key))
  add(query_579332, "prettyPrint", newJBool(prettyPrint))
  add(query_579332, "oauth_token", newJString(oauthToken))
  add(query_579332, "$.xgafv", newJString(Xgafv))
  add(query_579332, "alt", newJString(alt))
  add(query_579332, "uploadType", newJString(uploadType))
  add(query_579332, "quotaUser", newJString(quotaUser))
  add(query_579332, "callback", newJString(callback))
  add(path_579331, "parent", newJString(parent))
  add(query_579332, "fields", newJString(fields))
  add(query_579332, "access_token", newJString(accessToken))
  add(query_579332, "upload_protocol", newJString(uploadProtocol))
  result = call_579330.call(path_579331, query_579332, nil, nil, nil)

var androiddeviceprovisioningCustomersDpcsList* = Call_AndroiddeviceprovisioningCustomersDpcsList_579314(
    name: "androiddeviceprovisioningCustomersDpcsList", meth: HttpMethod.HttpGet,
    host: "androiddeviceprovisioning.googleapis.com", route: "/v1/{parent}/dpcs",
    validator: validate_AndroiddeviceprovisioningCustomersDpcsList_579315,
    base: "/", url: url_AndroiddeviceprovisioningCustomersDpcsList_579316,
    schemes: {Scheme.Https})
type
  Call_AndroiddeviceprovisioningPartnersVendorsList_579333 = ref object of OpenApiRestCall_578339
proc url_AndroiddeviceprovisioningPartnersVendorsList_579335(protocol: Scheme;
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

proc validate_AndroiddeviceprovisioningPartnersVendorsList_579334(path: JsonNode;
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
  var valid_579336 = path.getOrDefault("parent")
  valid_579336 = validateParameter(valid_579336, JString, required = true,
                                 default = nil)
  if valid_579336 != nil:
    section.add "parent", valid_579336
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
  var valid_579337 = query.getOrDefault("key")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "key", valid_579337
  var valid_579338 = query.getOrDefault("prettyPrint")
  valid_579338 = validateParameter(valid_579338, JBool, required = false,
                                 default = newJBool(true))
  if valid_579338 != nil:
    section.add "prettyPrint", valid_579338
  var valid_579339 = query.getOrDefault("oauth_token")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "oauth_token", valid_579339
  var valid_579340 = query.getOrDefault("$.xgafv")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = newJString("1"))
  if valid_579340 != nil:
    section.add "$.xgafv", valid_579340
  var valid_579341 = query.getOrDefault("pageSize")
  valid_579341 = validateParameter(valid_579341, JInt, required = false, default = nil)
  if valid_579341 != nil:
    section.add "pageSize", valid_579341
  var valid_579342 = query.getOrDefault("alt")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = newJString("json"))
  if valid_579342 != nil:
    section.add "alt", valid_579342
  var valid_579343 = query.getOrDefault("uploadType")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "uploadType", valid_579343
  var valid_579344 = query.getOrDefault("quotaUser")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = nil)
  if valid_579344 != nil:
    section.add "quotaUser", valid_579344
  var valid_579345 = query.getOrDefault("pageToken")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "pageToken", valid_579345
  var valid_579346 = query.getOrDefault("callback")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "callback", valid_579346
  var valid_579347 = query.getOrDefault("fields")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = nil)
  if valid_579347 != nil:
    section.add "fields", valid_579347
  var valid_579348 = query.getOrDefault("access_token")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = nil)
  if valid_579348 != nil:
    section.add "access_token", valid_579348
  var valid_579349 = query.getOrDefault("upload_protocol")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = nil)
  if valid_579349 != nil:
    section.add "upload_protocol", valid_579349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579350: Call_AndroiddeviceprovisioningPartnersVendorsList_579333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the vendors of the partner.
  ## 
  let valid = call_579350.validator(path, query, header, formData, body)
  let scheme = call_579350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579350.url(scheme.get, call_579350.host, call_579350.base,
                         call_579350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579350, url, valid)

proc call*(call_579351: Call_AndroiddeviceprovisioningPartnersVendorsList_579333;
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
  var path_579352 = newJObject()
  var query_579353 = newJObject()
  add(query_579353, "key", newJString(key))
  add(query_579353, "prettyPrint", newJBool(prettyPrint))
  add(query_579353, "oauth_token", newJString(oauthToken))
  add(query_579353, "$.xgafv", newJString(Xgafv))
  add(query_579353, "pageSize", newJInt(pageSize))
  add(query_579353, "alt", newJString(alt))
  add(query_579353, "uploadType", newJString(uploadType))
  add(query_579353, "quotaUser", newJString(quotaUser))
  add(query_579353, "pageToken", newJString(pageToken))
  add(query_579353, "callback", newJString(callback))
  add(path_579352, "parent", newJString(parent))
  add(query_579353, "fields", newJString(fields))
  add(query_579353, "access_token", newJString(accessToken))
  add(query_579353, "upload_protocol", newJString(uploadProtocol))
  result = call_579351.call(path_579352, query_579353, nil, nil, nil)

var androiddeviceprovisioningPartnersVendorsList* = Call_AndroiddeviceprovisioningPartnersVendorsList_579333(
    name: "androiddeviceprovisioningPartnersVendorsList",
    meth: HttpMethod.HttpGet, host: "androiddeviceprovisioning.googleapis.com",
    route: "/v1/{parent}/vendors",
    validator: validate_AndroiddeviceprovisioningPartnersVendorsList_579334,
    base: "/", url: url_AndroiddeviceprovisioningPartnersVendorsList_579335,
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
