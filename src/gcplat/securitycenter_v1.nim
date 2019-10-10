
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Security Command Center
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Cloud Security Command Center API provides access to temporal views of assets and findings within an organization.
## 
## https://console.cloud.google.com/apis/api/securitycenter.googleapis.com/overview
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
  gcpServiceName = "securitycenter"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SecuritycenterOrganizationsOperationsGet_588710 = ref object of OpenApiRestCall_588441
proc url_SecuritycenterOrganizationsOperationsGet_588712(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsOperationsGet_588711(path: JsonNode;
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
  var valid_588838 = path.getOrDefault("name")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "name", valid_588838
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
  var valid_588839 = query.getOrDefault("upload_protocol")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "upload_protocol", valid_588839
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("callback")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "callback", valid_588857
  var valid_588858 = query.getOrDefault("access_token")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "access_token", valid_588858
  var valid_588859 = query.getOrDefault("uploadType")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "uploadType", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("$.xgafv")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = newJString("1"))
  if valid_588861 != nil:
    section.add "$.xgafv", valid_588861
  var valid_588862 = query.getOrDefault("prettyPrint")
  valid_588862 = validateParameter(valid_588862, JBool, required = false,
                                 default = newJBool(true))
  if valid_588862 != nil:
    section.add "prettyPrint", valid_588862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588885: Call_SecuritycenterOrganizationsOperationsGet_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_588885.validator(path, query, header, formData, body)
  let scheme = call_588885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588885.url(scheme.get, call_588885.host, call_588885.base,
                         call_588885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588885, url, valid)

proc call*(call_588956: Call_SecuritycenterOrganizationsOperationsGet_588710;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsOperationsGet
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
  var path_588957 = newJObject()
  var query_588959 = newJObject()
  add(query_588959, "upload_protocol", newJString(uploadProtocol))
  add(query_588959, "fields", newJString(fields))
  add(query_588959, "quotaUser", newJString(quotaUser))
  add(path_588957, "name", newJString(name))
  add(query_588959, "alt", newJString(alt))
  add(query_588959, "oauth_token", newJString(oauthToken))
  add(query_588959, "callback", newJString(callback))
  add(query_588959, "access_token", newJString(accessToken))
  add(query_588959, "uploadType", newJString(uploadType))
  add(query_588959, "key", newJString(key))
  add(query_588959, "$.xgafv", newJString(Xgafv))
  add(query_588959, "prettyPrint", newJBool(prettyPrint))
  result = call_588956.call(path_588957, query_588959, nil, nil, nil)

var securitycenterOrganizationsOperationsGet* = Call_SecuritycenterOrganizationsOperationsGet_588710(
    name: "securitycenterOrganizationsOperationsGet", meth: HttpMethod.HttpGet,
    host: "securitycenter.googleapis.com", route: "/v1/{name}",
    validator: validate_SecuritycenterOrganizationsOperationsGet_588711,
    base: "/", url: url_SecuritycenterOrganizationsOperationsGet_588712,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsUpdateSecurityMarks_589017 = ref object of OpenApiRestCall_588441
proc url_SecuritycenterOrganizationsAssetsUpdateSecurityMarks_589019(
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

proc validate_SecuritycenterOrganizationsAssetsUpdateSecurityMarks_589018(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates security marks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The relative resource name of the SecurityMarks. See:
  ## https://cloud.google.com/apis/design/resource_names#relative_resource_name
  ## Examples:
  ## "organizations/123/assets/456/securityMarks"
  ## "organizations/123/sources/456/findings/789/securityMarks".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589020 = path.getOrDefault("name")
  valid_589020 = validateParameter(valid_589020, JString, required = true,
                                 default = nil)
  if valid_589020 != nil:
    section.add "name", valid_589020
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
  ##   startTime: JString
  ##            : The time at which the updated SecurityMarks take effect.
  ## If not set uses current server time.  Updates will be applied to the
  ## SecurityMarks that are active immediately preceding this time.
  ##   updateMask: JString
  ##             : The FieldMask to use when updating the security marks resource.
  ## 
  ## The field mask must not contain duplicate fields.
  ## If empty or set to "marks", all marks will be replaced.  Individual
  ## marks can be updated using "marks.<mark_key>".
  section = newJObject()
  var valid_589021 = query.getOrDefault("upload_protocol")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "upload_protocol", valid_589021
  var valid_589022 = query.getOrDefault("fields")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "fields", valid_589022
  var valid_589023 = query.getOrDefault("quotaUser")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "quotaUser", valid_589023
  var valid_589024 = query.getOrDefault("alt")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = newJString("json"))
  if valid_589024 != nil:
    section.add "alt", valid_589024
  var valid_589025 = query.getOrDefault("oauth_token")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "oauth_token", valid_589025
  var valid_589026 = query.getOrDefault("callback")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "callback", valid_589026
  var valid_589027 = query.getOrDefault("access_token")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "access_token", valid_589027
  var valid_589028 = query.getOrDefault("uploadType")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "uploadType", valid_589028
  var valid_589029 = query.getOrDefault("key")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "key", valid_589029
  var valid_589030 = query.getOrDefault("$.xgafv")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = newJString("1"))
  if valid_589030 != nil:
    section.add "$.xgafv", valid_589030
  var valid_589031 = query.getOrDefault("prettyPrint")
  valid_589031 = validateParameter(valid_589031, JBool, required = false,
                                 default = newJBool(true))
  if valid_589031 != nil:
    section.add "prettyPrint", valid_589031
  var valid_589032 = query.getOrDefault("startTime")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "startTime", valid_589032
  var valid_589033 = query.getOrDefault("updateMask")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "updateMask", valid_589033
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

proc call*(call_589035: Call_SecuritycenterOrganizationsAssetsUpdateSecurityMarks_589017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates security marks.
  ## 
  let valid = call_589035.validator(path, query, header, formData, body)
  let scheme = call_589035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589035.url(scheme.get, call_589035.host, call_589035.base,
                         call_589035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589035, url, valid)

proc call*(call_589036: Call_SecuritycenterOrganizationsAssetsUpdateSecurityMarks_589017;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; startTime: string = ""; updateMask: string = ""): Recallable =
  ## securitycenterOrganizationsAssetsUpdateSecurityMarks
  ## Updates security marks.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The relative resource name of the SecurityMarks. See:
  ## https://cloud.google.com/apis/design/resource_names#relative_resource_name
  ## Examples:
  ## "organizations/123/assets/456/securityMarks"
  ## "organizations/123/sources/456/findings/789/securityMarks".
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
  ##   startTime: string
  ##            : The time at which the updated SecurityMarks take effect.
  ## If not set uses current server time.  Updates will be applied to the
  ## SecurityMarks that are active immediately preceding this time.
  ##   updateMask: string
  ##             : The FieldMask to use when updating the security marks resource.
  ## 
  ## The field mask must not contain duplicate fields.
  ## If empty or set to "marks", all marks will be replaced.  Individual
  ## marks can be updated using "marks.<mark_key>".
  var path_589037 = newJObject()
  var query_589038 = newJObject()
  var body_589039 = newJObject()
  add(query_589038, "upload_protocol", newJString(uploadProtocol))
  add(query_589038, "fields", newJString(fields))
  add(query_589038, "quotaUser", newJString(quotaUser))
  add(path_589037, "name", newJString(name))
  add(query_589038, "alt", newJString(alt))
  add(query_589038, "oauth_token", newJString(oauthToken))
  add(query_589038, "callback", newJString(callback))
  add(query_589038, "access_token", newJString(accessToken))
  add(query_589038, "uploadType", newJString(uploadType))
  add(query_589038, "key", newJString(key))
  add(query_589038, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589039 = body
  add(query_589038, "prettyPrint", newJBool(prettyPrint))
  add(query_589038, "startTime", newJString(startTime))
  add(query_589038, "updateMask", newJString(updateMask))
  result = call_589036.call(path_589037, query_589038, nil, nil, body_589039)

var securitycenterOrganizationsAssetsUpdateSecurityMarks* = Call_SecuritycenterOrganizationsAssetsUpdateSecurityMarks_589017(
    name: "securitycenterOrganizationsAssetsUpdateSecurityMarks",
    meth: HttpMethod.HttpPatch, host: "securitycenter.googleapis.com",
    route: "/v1/{name}",
    validator: validate_SecuritycenterOrganizationsAssetsUpdateSecurityMarks_589018,
    base: "/", url: url_SecuritycenterOrganizationsAssetsUpdateSecurityMarks_589019,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsOperationsDelete_588998 = ref object of OpenApiRestCall_588441
proc url_SecuritycenterOrganizationsOperationsDelete_589000(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsOperationsDelete_588999(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589001 = path.getOrDefault("name")
  valid_589001 = validateParameter(valid_589001, JString, required = true,
                                 default = nil)
  if valid_589001 != nil:
    section.add "name", valid_589001
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
  var valid_589002 = query.getOrDefault("upload_protocol")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "upload_protocol", valid_589002
  var valid_589003 = query.getOrDefault("fields")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "fields", valid_589003
  var valid_589004 = query.getOrDefault("quotaUser")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "quotaUser", valid_589004
  var valid_589005 = query.getOrDefault("alt")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = newJString("json"))
  if valid_589005 != nil:
    section.add "alt", valid_589005
  var valid_589006 = query.getOrDefault("oauth_token")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "oauth_token", valid_589006
  var valid_589007 = query.getOrDefault("callback")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "callback", valid_589007
  var valid_589008 = query.getOrDefault("access_token")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "access_token", valid_589008
  var valid_589009 = query.getOrDefault("uploadType")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "uploadType", valid_589009
  var valid_589010 = query.getOrDefault("key")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "key", valid_589010
  var valid_589011 = query.getOrDefault("$.xgafv")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("1"))
  if valid_589011 != nil:
    section.add "$.xgafv", valid_589011
  var valid_589012 = query.getOrDefault("prettyPrint")
  valid_589012 = validateParameter(valid_589012, JBool, required = false,
                                 default = newJBool(true))
  if valid_589012 != nil:
    section.add "prettyPrint", valid_589012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589013: Call_SecuritycenterOrganizationsOperationsDelete_588998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_589013.validator(path, query, header, formData, body)
  let scheme = call_589013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589013.url(scheme.get, call_589013.host, call_589013.base,
                         call_589013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589013, url, valid)

proc call*(call_589014: Call_SecuritycenterOrganizationsOperationsDelete_588998;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
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
  var path_589015 = newJObject()
  var query_589016 = newJObject()
  add(query_589016, "upload_protocol", newJString(uploadProtocol))
  add(query_589016, "fields", newJString(fields))
  add(query_589016, "quotaUser", newJString(quotaUser))
  add(path_589015, "name", newJString(name))
  add(query_589016, "alt", newJString(alt))
  add(query_589016, "oauth_token", newJString(oauthToken))
  add(query_589016, "callback", newJString(callback))
  add(query_589016, "access_token", newJString(accessToken))
  add(query_589016, "uploadType", newJString(uploadType))
  add(query_589016, "key", newJString(key))
  add(query_589016, "$.xgafv", newJString(Xgafv))
  add(query_589016, "prettyPrint", newJBool(prettyPrint))
  result = call_589014.call(path_589015, query_589016, nil, nil, nil)

var securitycenterOrganizationsOperationsDelete* = Call_SecuritycenterOrganizationsOperationsDelete_588998(
    name: "securitycenterOrganizationsOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "securitycenter.googleapis.com",
    route: "/v1/{name}",
    validator: validate_SecuritycenterOrganizationsOperationsDelete_588999,
    base: "/", url: url_SecuritycenterOrganizationsOperationsDelete_589000,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsOperationsCancel_589040 = ref object of OpenApiRestCall_588441
proc url_SecuritycenterOrganizationsOperationsCancel_589042(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsOperationsCancel_589041(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589043 = path.getOrDefault("name")
  valid_589043 = validateParameter(valid_589043, JString, required = true,
                                 default = nil)
  if valid_589043 != nil:
    section.add "name", valid_589043
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
  var valid_589044 = query.getOrDefault("upload_protocol")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "upload_protocol", valid_589044
  var valid_589045 = query.getOrDefault("fields")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "fields", valid_589045
  var valid_589046 = query.getOrDefault("quotaUser")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "quotaUser", valid_589046
  var valid_589047 = query.getOrDefault("alt")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = newJString("json"))
  if valid_589047 != nil:
    section.add "alt", valid_589047
  var valid_589048 = query.getOrDefault("oauth_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "oauth_token", valid_589048
  var valid_589049 = query.getOrDefault("callback")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "callback", valid_589049
  var valid_589050 = query.getOrDefault("access_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "access_token", valid_589050
  var valid_589051 = query.getOrDefault("uploadType")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "uploadType", valid_589051
  var valid_589052 = query.getOrDefault("key")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "key", valid_589052
  var valid_589053 = query.getOrDefault("$.xgafv")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = newJString("1"))
  if valid_589053 != nil:
    section.add "$.xgafv", valid_589053
  var valid_589054 = query.getOrDefault("prettyPrint")
  valid_589054 = validateParameter(valid_589054, JBool, required = false,
                                 default = newJBool(true))
  if valid_589054 != nil:
    section.add "prettyPrint", valid_589054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589055: Call_SecuritycenterOrganizationsOperationsCancel_589040;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_589055.validator(path, query, header, formData, body)
  let scheme = call_589055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589055.url(scheme.get, call_589055.host, call_589055.base,
                         call_589055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589055, url, valid)

proc call*(call_589056: Call_SecuritycenterOrganizationsOperationsCancel_589040;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
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
  var path_589057 = newJObject()
  var query_589058 = newJObject()
  add(query_589058, "upload_protocol", newJString(uploadProtocol))
  add(query_589058, "fields", newJString(fields))
  add(query_589058, "quotaUser", newJString(quotaUser))
  add(path_589057, "name", newJString(name))
  add(query_589058, "alt", newJString(alt))
  add(query_589058, "oauth_token", newJString(oauthToken))
  add(query_589058, "callback", newJString(callback))
  add(query_589058, "access_token", newJString(accessToken))
  add(query_589058, "uploadType", newJString(uploadType))
  add(query_589058, "key", newJString(key))
  add(query_589058, "$.xgafv", newJString(Xgafv))
  add(query_589058, "prettyPrint", newJBool(prettyPrint))
  result = call_589056.call(path_589057, query_589058, nil, nil, nil)

var securitycenterOrganizationsOperationsCancel* = Call_SecuritycenterOrganizationsOperationsCancel_589040(
    name: "securitycenterOrganizationsOperationsCancel",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{name}:cancel",
    validator: validate_SecuritycenterOrganizationsOperationsCancel_589041,
    base: "/", url: url_SecuritycenterOrganizationsOperationsCancel_589042,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsSetState_589059 = ref object of OpenApiRestCall_588441
proc url_SecuritycenterOrganizationsSourcesFindingsSetState_589061(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":setState")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesFindingsSetState_589060(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the state of a finding.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The relative resource name of the finding. See:
  ## https://cloud.google.com/apis/design/resource_names#relative_resource_name
  ## Example:
  ## "organizations/123/sources/456/finding/789".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589062 = path.getOrDefault("name")
  valid_589062 = validateParameter(valid_589062, JString, required = true,
                                 default = nil)
  if valid_589062 != nil:
    section.add "name", valid_589062
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
  var valid_589063 = query.getOrDefault("upload_protocol")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "upload_protocol", valid_589063
  var valid_589064 = query.getOrDefault("fields")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "fields", valid_589064
  var valid_589065 = query.getOrDefault("quotaUser")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "quotaUser", valid_589065
  var valid_589066 = query.getOrDefault("alt")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = newJString("json"))
  if valid_589066 != nil:
    section.add "alt", valid_589066
  var valid_589067 = query.getOrDefault("oauth_token")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "oauth_token", valid_589067
  var valid_589068 = query.getOrDefault("callback")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "callback", valid_589068
  var valid_589069 = query.getOrDefault("access_token")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "access_token", valid_589069
  var valid_589070 = query.getOrDefault("uploadType")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "uploadType", valid_589070
  var valid_589071 = query.getOrDefault("key")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "key", valid_589071
  var valid_589072 = query.getOrDefault("$.xgafv")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = newJString("1"))
  if valid_589072 != nil:
    section.add "$.xgafv", valid_589072
  var valid_589073 = query.getOrDefault("prettyPrint")
  valid_589073 = validateParameter(valid_589073, JBool, required = false,
                                 default = newJBool(true))
  if valid_589073 != nil:
    section.add "prettyPrint", valid_589073
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

proc call*(call_589075: Call_SecuritycenterOrganizationsSourcesFindingsSetState_589059;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the state of a finding.
  ## 
  let valid = call_589075.validator(path, query, header, formData, body)
  let scheme = call_589075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589075.url(scheme.get, call_589075.host, call_589075.base,
                         call_589075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589075, url, valid)

proc call*(call_589076: Call_SecuritycenterOrganizationsSourcesFindingsSetState_589059;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsSourcesFindingsSetState
  ## Updates the state of a finding.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The relative resource name of the finding. See:
  ## https://cloud.google.com/apis/design/resource_names#relative_resource_name
  ## Example:
  ## "organizations/123/sources/456/finding/789".
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
  var path_589077 = newJObject()
  var query_589078 = newJObject()
  var body_589079 = newJObject()
  add(query_589078, "upload_protocol", newJString(uploadProtocol))
  add(query_589078, "fields", newJString(fields))
  add(query_589078, "quotaUser", newJString(quotaUser))
  add(path_589077, "name", newJString(name))
  add(query_589078, "alt", newJString(alt))
  add(query_589078, "oauth_token", newJString(oauthToken))
  add(query_589078, "callback", newJString(callback))
  add(query_589078, "access_token", newJString(accessToken))
  add(query_589078, "uploadType", newJString(uploadType))
  add(query_589078, "key", newJString(key))
  add(query_589078, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589079 = body
  add(query_589078, "prettyPrint", newJBool(prettyPrint))
  result = call_589076.call(path_589077, query_589078, nil, nil, body_589079)

var securitycenterOrganizationsSourcesFindingsSetState* = Call_SecuritycenterOrganizationsSourcesFindingsSetState_589059(
    name: "securitycenterOrganizationsSourcesFindingsSetState",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{name}:setState",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsSetState_589060,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsSetState_589061,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsList_589080 = ref object of OpenApiRestCall_588441
proc url_SecuritycenterOrganizationsAssetsList_589082(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/assets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsAssetsList_589081(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists an organization's assets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Name of the organization assets should belong to. Its format is
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589083 = path.getOrDefault("parent")
  valid_589083 = validateParameter(valid_589083, JString, required = true,
                                 default = nil)
  if valid_589083 != nil:
    section.add "parent", valid_589083
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value returned by the last `ListAssetsResponse`; indicates
  ## that this is a continuation of a prior `ListAssets` call, and
  ## that the system should return the next page of data.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   readTime: JString
  ##           : Time used as a reference point when filtering assets. The filter is limited
  ## to assets existing at the supplied time and their values are those at that
  ## specific time. Absence of this field will default to the API's version of
  ## NOW.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Expression that defines what fields and order to use for sorting. The
  ## string value should follow SQL syntax: comma separated list of fields. For
  ## example: "name,resource_properties.a_property". The default sorting order
  ## is ascending. To specify descending order for a field, a suffix " desc"
  ## should be appended to the field name. For example: "name
  ## desc,resource_properties.a_property". Redundant space characters in the
  ## syntax are insignificant. "name desc,resource_properties.a_property" and "
  ## name     desc  ,   resource_properties.a_property  " are equivalent.
  ## 
  ## The following fields are supported:
  ## name
  ## update_time
  ## resource_properties
  ## security_marks.marks
  ## security_center_properties.resource_name
  ## security_center_properties.resource_parent
  ## security_center_properties.resource_project
  ## security_center_properties.resource_type
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fieldMask: JString
  ##            : Optional. A field mask to specify the ListAssetsResult fields to be listed in the
  ## response.
  ## An empty field mask will list all fields.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   compareDuration: JString
  ##                  : When compare_duration is set, the ListAssetsResult's "state_change"
  ## attribute is updated to indicate whether the asset was added, removed, or
  ## remained present during the compare_duration period of time that precedes
  ## the read_time. This is the time between (read_time - compare_duration) and
  ## read_time.
  ## 
  ## The state_change value is derived based on the presence of the asset at the
  ## two points in time. Intermediate state changes between the two times don't
  ## affect the result. For example, the results aren't affected if the asset is
  ## removed and re-created again.
  ## 
  ## Possible "state_change" values when compare_duration is specified:
  ## 
  ## * "ADDED":   indicates that the asset was not present at the start of
  ##                compare_duration, but present at read_time.
  ## * "REMOVED": indicates that the asset was present at the start of
  ##                compare_duration, but not present at read_time.
  ## * "ACTIVE":  indicates that the asset was present at both the
  ##                start and the end of the time period defined by
  ##                compare_duration and read_time.
  ## 
  ## If compare_duration is not specified, then the only possible state_change
  ## is "UNUSED",  which will be the state_change set for all assets present at
  ## read_time.
  ##   pageSize: JInt
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Expression that defines the filter to apply across assets.
  ## The expression is a list of zero or more restrictions combined via logical
  ## operators `AND` and `OR`.
  ## Parentheses are supported, and `OR` has higher precedence than `AND`.
  ## 
  ## Restrictions have the form `<field> <operator> <value>` and may have a `-`
  ## character in front of them to indicate negation. The fields map to those
  ## defined in the Asset resource. Examples include:
  ## 
  ## * name
  ## * security_center_properties.resource_name
  ## * resource_properties.a_property
  ## * security_marks.marks.marka
  ## 
  ## The supported operators are:
  ## 
  ## * `=` for all value types.
  ## * `>`, `<`, `>=`, `<=` for integer values.
  ## * `:`, meaning substring matching, for strings.
  ## 
  ## The supported value types are:
  ## 
  ## * string literals in quotes.
  ## * integer literals without quotes.
  ## * boolean literals `true` and `false` without quotes.
  ## 
  ## The following are the allowed field and operator combinations:
  ## 
  ## * name: `=`
  ## * update_time: `=`, `>`, `<`, `>=`, `<=`
  ## 
  ##   Usage: This should be milliseconds since epoch or an RFC3339 string.
  ##   Examples:
  ##     "update_time = \"2019-06-10T16:07:18-07:00\""
  ##     "update_time = 1560208038000"
  ## 
  ## * create_time: `=`, `>`, `<`, `>=`, `<=`
  ## 
  ##   Usage: This should be milliseconds since epoch or an RFC3339 string.
  ##   Examples:
  ##     "create_time = \"2019-06-10T16:07:18-07:00\""
  ##     "create_time = 1560208038000"
  ## 
  ## * iam_policy.policy_blob: `=`, `:`
  ## * resource_properties: `=`, `:`, `>`, `<`, `>=`, `<=`
  ## * security_marks.marks: `=`, `:`
  ## * security_center_properties.resource_name: `=`, `:`
  ## * security_center_properties.resource_type: `=`, `:`
  ## * security_center_properties.resource_parent: `=`, `:`
  ## * security_center_properties.resource_project: `=`, `:`
  ## * security_center_properties.resource_owners: `=`, `:`
  ## 
  ## For example, `resource_properties.size = 100` is a valid filter string.
  section = newJObject()
  var valid_589084 = query.getOrDefault("upload_protocol")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "upload_protocol", valid_589084
  var valid_589085 = query.getOrDefault("fields")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "fields", valid_589085
  var valid_589086 = query.getOrDefault("pageToken")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "pageToken", valid_589086
  var valid_589087 = query.getOrDefault("quotaUser")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "quotaUser", valid_589087
  var valid_589088 = query.getOrDefault("alt")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = newJString("json"))
  if valid_589088 != nil:
    section.add "alt", valid_589088
  var valid_589089 = query.getOrDefault("readTime")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "readTime", valid_589089
  var valid_589090 = query.getOrDefault("oauth_token")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "oauth_token", valid_589090
  var valid_589091 = query.getOrDefault("callback")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "callback", valid_589091
  var valid_589092 = query.getOrDefault("access_token")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "access_token", valid_589092
  var valid_589093 = query.getOrDefault("uploadType")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "uploadType", valid_589093
  var valid_589094 = query.getOrDefault("orderBy")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "orderBy", valid_589094
  var valid_589095 = query.getOrDefault("key")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "key", valid_589095
  var valid_589096 = query.getOrDefault("fieldMask")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "fieldMask", valid_589096
  var valid_589097 = query.getOrDefault("$.xgafv")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = newJString("1"))
  if valid_589097 != nil:
    section.add "$.xgafv", valid_589097
  var valid_589098 = query.getOrDefault("compareDuration")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "compareDuration", valid_589098
  var valid_589099 = query.getOrDefault("pageSize")
  valid_589099 = validateParameter(valid_589099, JInt, required = false, default = nil)
  if valid_589099 != nil:
    section.add "pageSize", valid_589099
  var valid_589100 = query.getOrDefault("prettyPrint")
  valid_589100 = validateParameter(valid_589100, JBool, required = false,
                                 default = newJBool(true))
  if valid_589100 != nil:
    section.add "prettyPrint", valid_589100
  var valid_589101 = query.getOrDefault("filter")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "filter", valid_589101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589102: Call_SecuritycenterOrganizationsAssetsList_589080;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists an organization's assets.
  ## 
  let valid = call_589102.validator(path, query, header, formData, body)
  let scheme = call_589102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589102.url(scheme.get, call_589102.host, call_589102.base,
                         call_589102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589102, url, valid)

proc call*(call_589103: Call_SecuritycenterOrganizationsAssetsList_589080;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          readTime: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; orderBy: string = "";
          key: string = ""; fieldMask: string = ""; Xgafv: string = "1";
          compareDuration: string = ""; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## securitycenterOrganizationsAssetsList
  ## Lists an organization's assets.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last `ListAssetsResponse`; indicates
  ## that this is a continuation of a prior `ListAssets` call, and
  ## that the system should return the next page of data.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   readTime: string
  ##           : Time used as a reference point when filtering assets. The filter is limited
  ## to assets existing at the supplied time and their values are those at that
  ## specific time. Absence of this field will default to the API's version of
  ## NOW.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. Name of the organization assets should belong to. Its format is
  ## "organizations/[organization_id]".
  ##   orderBy: string
  ##          : Expression that defines what fields and order to use for sorting. The
  ## string value should follow SQL syntax: comma separated list of fields. For
  ## example: "name,resource_properties.a_property". The default sorting order
  ## is ascending. To specify descending order for a field, a suffix " desc"
  ## should be appended to the field name. For example: "name
  ## desc,resource_properties.a_property". Redundant space characters in the
  ## syntax are insignificant. "name desc,resource_properties.a_property" and "
  ## name     desc  ,   resource_properties.a_property  " are equivalent.
  ## 
  ## The following fields are supported:
  ## name
  ## update_time
  ## resource_properties
  ## security_marks.marks
  ## security_center_properties.resource_name
  ## security_center_properties.resource_parent
  ## security_center_properties.resource_project
  ## security_center_properties.resource_type
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fieldMask: string
  ##            : Optional. A field mask to specify the ListAssetsResult fields to be listed in the
  ## response.
  ## An empty field mask will list all fields.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   compareDuration: string
  ##                  : When compare_duration is set, the ListAssetsResult's "state_change"
  ## attribute is updated to indicate whether the asset was added, removed, or
  ## remained present during the compare_duration period of time that precedes
  ## the read_time. This is the time between (read_time - compare_duration) and
  ## read_time.
  ## 
  ## The state_change value is derived based on the presence of the asset at the
  ## two points in time. Intermediate state changes between the two times don't
  ## affect the result. For example, the results aren't affected if the asset is
  ## removed and re-created again.
  ## 
  ## Possible "state_change" values when compare_duration is specified:
  ## 
  ## * "ADDED":   indicates that the asset was not present at the start of
  ##                compare_duration, but present at read_time.
  ## * "REMOVED": indicates that the asset was present at the start of
  ##                compare_duration, but not present at read_time.
  ## * "ACTIVE":  indicates that the asset was present at both the
  ##                start and the end of the time period defined by
  ##                compare_duration and read_time.
  ## 
  ## If compare_duration is not specified, then the only possible state_change
  ## is "UNUSED",  which will be the state_change set for all assets present at
  ## read_time.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Expression that defines the filter to apply across assets.
  ## The expression is a list of zero or more restrictions combined via logical
  ## operators `AND` and `OR`.
  ## Parentheses are supported, and `OR` has higher precedence than `AND`.
  ## 
  ## Restrictions have the form `<field> <operator> <value>` and may have a `-`
  ## character in front of them to indicate negation. The fields map to those
  ## defined in the Asset resource. Examples include:
  ## 
  ## * name
  ## * security_center_properties.resource_name
  ## * resource_properties.a_property
  ## * security_marks.marks.marka
  ## 
  ## The supported operators are:
  ## 
  ## * `=` for all value types.
  ## * `>`, `<`, `>=`, `<=` for integer values.
  ## * `:`, meaning substring matching, for strings.
  ## 
  ## The supported value types are:
  ## 
  ## * string literals in quotes.
  ## * integer literals without quotes.
  ## * boolean literals `true` and `false` without quotes.
  ## 
  ## The following are the allowed field and operator combinations:
  ## 
  ## * name: `=`
  ## * update_time: `=`, `>`, `<`, `>=`, `<=`
  ## 
  ##   Usage: This should be milliseconds since epoch or an RFC3339 string.
  ##   Examples:
  ##     "update_time = \"2019-06-10T16:07:18-07:00\""
  ##     "update_time = 1560208038000"
  ## 
  ## * create_time: `=`, `>`, `<`, `>=`, `<=`
  ## 
  ##   Usage: This should be milliseconds since epoch or an RFC3339 string.
  ##   Examples:
  ##     "create_time = \"2019-06-10T16:07:18-07:00\""
  ##     "create_time = 1560208038000"
  ## 
  ## * iam_policy.policy_blob: `=`, `:`
  ## * resource_properties: `=`, `:`, `>`, `<`, `>=`, `<=`
  ## * security_marks.marks: `=`, `:`
  ## * security_center_properties.resource_name: `=`, `:`
  ## * security_center_properties.resource_type: `=`, `:`
  ## * security_center_properties.resource_parent: `=`, `:`
  ## * security_center_properties.resource_project: `=`, `:`
  ## * security_center_properties.resource_owners: `=`, `:`
  ## 
  ## For example, `resource_properties.size = 100` is a valid filter string.
  var path_589104 = newJObject()
  var query_589105 = newJObject()
  add(query_589105, "upload_protocol", newJString(uploadProtocol))
  add(query_589105, "fields", newJString(fields))
  add(query_589105, "pageToken", newJString(pageToken))
  add(query_589105, "quotaUser", newJString(quotaUser))
  add(query_589105, "alt", newJString(alt))
  add(query_589105, "readTime", newJString(readTime))
  add(query_589105, "oauth_token", newJString(oauthToken))
  add(query_589105, "callback", newJString(callback))
  add(query_589105, "access_token", newJString(accessToken))
  add(query_589105, "uploadType", newJString(uploadType))
  add(path_589104, "parent", newJString(parent))
  add(query_589105, "orderBy", newJString(orderBy))
  add(query_589105, "key", newJString(key))
  add(query_589105, "fieldMask", newJString(fieldMask))
  add(query_589105, "$.xgafv", newJString(Xgafv))
  add(query_589105, "compareDuration", newJString(compareDuration))
  add(query_589105, "pageSize", newJInt(pageSize))
  add(query_589105, "prettyPrint", newJBool(prettyPrint))
  add(query_589105, "filter", newJString(filter))
  result = call_589103.call(path_589104, query_589105, nil, nil, nil)

var securitycenterOrganizationsAssetsList* = Call_SecuritycenterOrganizationsAssetsList_589080(
    name: "securitycenterOrganizationsAssetsList", meth: HttpMethod.HttpGet,
    host: "securitycenter.googleapis.com", route: "/v1/{parent}/assets",
    validator: validate_SecuritycenterOrganizationsAssetsList_589081, base: "/",
    url: url_SecuritycenterOrganizationsAssetsList_589082, schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsGroup_589106 = ref object of OpenApiRestCall_588441
proc url_SecuritycenterOrganizationsAssetsGroup_589108(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/assets:group")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsAssetsGroup_589107(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Filters an organization's assets and  groups them by their specified
  ## properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Name of the organization to groupBy. Its format is
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589109 = path.getOrDefault("parent")
  valid_589109 = validateParameter(valid_589109, JString, required = true,
                                 default = nil)
  if valid_589109 != nil:
    section.add "parent", valid_589109
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
  var valid_589110 = query.getOrDefault("upload_protocol")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "upload_protocol", valid_589110
  var valid_589111 = query.getOrDefault("fields")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "fields", valid_589111
  var valid_589112 = query.getOrDefault("quotaUser")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "quotaUser", valid_589112
  var valid_589113 = query.getOrDefault("alt")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = newJString("json"))
  if valid_589113 != nil:
    section.add "alt", valid_589113
  var valid_589114 = query.getOrDefault("oauth_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "oauth_token", valid_589114
  var valid_589115 = query.getOrDefault("callback")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "callback", valid_589115
  var valid_589116 = query.getOrDefault("access_token")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "access_token", valid_589116
  var valid_589117 = query.getOrDefault("uploadType")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "uploadType", valid_589117
  var valid_589118 = query.getOrDefault("key")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "key", valid_589118
  var valid_589119 = query.getOrDefault("$.xgafv")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = newJString("1"))
  if valid_589119 != nil:
    section.add "$.xgafv", valid_589119
  var valid_589120 = query.getOrDefault("prettyPrint")
  valid_589120 = validateParameter(valid_589120, JBool, required = false,
                                 default = newJBool(true))
  if valid_589120 != nil:
    section.add "prettyPrint", valid_589120
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

proc call*(call_589122: Call_SecuritycenterOrganizationsAssetsGroup_589106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Filters an organization's assets and  groups them by their specified
  ## properties.
  ## 
  let valid = call_589122.validator(path, query, header, formData, body)
  let scheme = call_589122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589122.url(scheme.get, call_589122.host, call_589122.base,
                         call_589122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589122, url, valid)

proc call*(call_589123: Call_SecuritycenterOrganizationsAssetsGroup_589106;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsAssetsGroup
  ## Filters an organization's assets and  groups them by their specified
  ## properties.
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
  ##         : Required. Name of the organization to groupBy. Its format is
  ## "organizations/[organization_id]".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589124 = newJObject()
  var query_589125 = newJObject()
  var body_589126 = newJObject()
  add(query_589125, "upload_protocol", newJString(uploadProtocol))
  add(query_589125, "fields", newJString(fields))
  add(query_589125, "quotaUser", newJString(quotaUser))
  add(query_589125, "alt", newJString(alt))
  add(query_589125, "oauth_token", newJString(oauthToken))
  add(query_589125, "callback", newJString(callback))
  add(query_589125, "access_token", newJString(accessToken))
  add(query_589125, "uploadType", newJString(uploadType))
  add(path_589124, "parent", newJString(parent))
  add(query_589125, "key", newJString(key))
  add(query_589125, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589126 = body
  add(query_589125, "prettyPrint", newJBool(prettyPrint))
  result = call_589123.call(path_589124, query_589125, nil, nil, body_589126)

var securitycenterOrganizationsAssetsGroup* = Call_SecuritycenterOrganizationsAssetsGroup_589106(
    name: "securitycenterOrganizationsAssetsGroup", meth: HttpMethod.HttpPost,
    host: "securitycenter.googleapis.com", route: "/v1/{parent}/assets:group",
    validator: validate_SecuritycenterOrganizationsAssetsGroup_589107, base: "/",
    url: url_SecuritycenterOrganizationsAssetsGroup_589108,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsRunDiscovery_589127 = ref object of OpenApiRestCall_588441
proc url_SecuritycenterOrganizationsAssetsRunDiscovery_589129(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/assets:runDiscovery")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsAssetsRunDiscovery_589128(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Runs asset discovery. The discovery is tracked with a long-running
  ## operation.
  ## 
  ## This API can only be called with limited frequency for an organization. If
  ## it is called too frequently the caller will receive a TOO_MANY_REQUESTS
  ## error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Name of the organization to run asset discovery for. Its format is
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589130 = path.getOrDefault("parent")
  valid_589130 = validateParameter(valid_589130, JString, required = true,
                                 default = nil)
  if valid_589130 != nil:
    section.add "parent", valid_589130
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
  var valid_589131 = query.getOrDefault("upload_protocol")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "upload_protocol", valid_589131
  var valid_589132 = query.getOrDefault("fields")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "fields", valid_589132
  var valid_589133 = query.getOrDefault("quotaUser")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "quotaUser", valid_589133
  var valid_589134 = query.getOrDefault("alt")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = newJString("json"))
  if valid_589134 != nil:
    section.add "alt", valid_589134
  var valid_589135 = query.getOrDefault("oauth_token")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "oauth_token", valid_589135
  var valid_589136 = query.getOrDefault("callback")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "callback", valid_589136
  var valid_589137 = query.getOrDefault("access_token")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "access_token", valid_589137
  var valid_589138 = query.getOrDefault("uploadType")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "uploadType", valid_589138
  var valid_589139 = query.getOrDefault("key")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "key", valid_589139
  var valid_589140 = query.getOrDefault("$.xgafv")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = newJString("1"))
  if valid_589140 != nil:
    section.add "$.xgafv", valid_589140
  var valid_589141 = query.getOrDefault("prettyPrint")
  valid_589141 = validateParameter(valid_589141, JBool, required = false,
                                 default = newJBool(true))
  if valid_589141 != nil:
    section.add "prettyPrint", valid_589141
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

proc call*(call_589143: Call_SecuritycenterOrganizationsAssetsRunDiscovery_589127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs asset discovery. The discovery is tracked with a long-running
  ## operation.
  ## 
  ## This API can only be called with limited frequency for an organization. If
  ## it is called too frequently the caller will receive a TOO_MANY_REQUESTS
  ## error.
  ## 
  let valid = call_589143.validator(path, query, header, formData, body)
  let scheme = call_589143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589143.url(scheme.get, call_589143.host, call_589143.base,
                         call_589143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589143, url, valid)

proc call*(call_589144: Call_SecuritycenterOrganizationsAssetsRunDiscovery_589127;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsAssetsRunDiscovery
  ## Runs asset discovery. The discovery is tracked with a long-running
  ## operation.
  ## 
  ## This API can only be called with limited frequency for an organization. If
  ## it is called too frequently the caller will receive a TOO_MANY_REQUESTS
  ## error.
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
  ##         : Required. Name of the organization to run asset discovery for. Its format is
  ## "organizations/[organization_id]".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589145 = newJObject()
  var query_589146 = newJObject()
  var body_589147 = newJObject()
  add(query_589146, "upload_protocol", newJString(uploadProtocol))
  add(query_589146, "fields", newJString(fields))
  add(query_589146, "quotaUser", newJString(quotaUser))
  add(query_589146, "alt", newJString(alt))
  add(query_589146, "oauth_token", newJString(oauthToken))
  add(query_589146, "callback", newJString(callback))
  add(query_589146, "access_token", newJString(accessToken))
  add(query_589146, "uploadType", newJString(uploadType))
  add(path_589145, "parent", newJString(parent))
  add(query_589146, "key", newJString(key))
  add(query_589146, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589147 = body
  add(query_589146, "prettyPrint", newJBool(prettyPrint))
  result = call_589144.call(path_589145, query_589146, nil, nil, body_589147)

var securitycenterOrganizationsAssetsRunDiscovery* = Call_SecuritycenterOrganizationsAssetsRunDiscovery_589127(
    name: "securitycenterOrganizationsAssetsRunDiscovery",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{parent}/assets:runDiscovery",
    validator: validate_SecuritycenterOrganizationsAssetsRunDiscovery_589128,
    base: "/", url: url_SecuritycenterOrganizationsAssetsRunDiscovery_589129,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsCreate_589174 = ref object of OpenApiRestCall_588441
proc url_SecuritycenterOrganizationsSourcesFindingsCreate_589176(
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
               (kind: ConstantSegment, value: "/findings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesFindingsCreate_589175(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a finding. The corresponding source must exist for finding creation
  ## to succeed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Resource name of the new finding's parent. Its format should be
  ## "organizations/[organization_id]/sources/[source_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589177 = path.getOrDefault("parent")
  valid_589177 = validateParameter(valid_589177, JString, required = true,
                                 default = nil)
  if valid_589177 != nil:
    section.add "parent", valid_589177
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   findingId: JString
  ##            : Required. Unique identifier provided by the client within the parent scope.
  ## It must be alphanumeric and less than or equal to 32 characters and
  ## greater than 0 characters in length.
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
  var valid_589178 = query.getOrDefault("upload_protocol")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "upload_protocol", valid_589178
  var valid_589179 = query.getOrDefault("fields")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "fields", valid_589179
  var valid_589180 = query.getOrDefault("quotaUser")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "quotaUser", valid_589180
  var valid_589181 = query.getOrDefault("findingId")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "findingId", valid_589181
  var valid_589182 = query.getOrDefault("alt")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = newJString("json"))
  if valid_589182 != nil:
    section.add "alt", valid_589182
  var valid_589183 = query.getOrDefault("oauth_token")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "oauth_token", valid_589183
  var valid_589184 = query.getOrDefault("callback")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "callback", valid_589184
  var valid_589185 = query.getOrDefault("access_token")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "access_token", valid_589185
  var valid_589186 = query.getOrDefault("uploadType")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "uploadType", valid_589186
  var valid_589187 = query.getOrDefault("key")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "key", valid_589187
  var valid_589188 = query.getOrDefault("$.xgafv")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = newJString("1"))
  if valid_589188 != nil:
    section.add "$.xgafv", valid_589188
  var valid_589189 = query.getOrDefault("prettyPrint")
  valid_589189 = validateParameter(valid_589189, JBool, required = false,
                                 default = newJBool(true))
  if valid_589189 != nil:
    section.add "prettyPrint", valid_589189
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

proc call*(call_589191: Call_SecuritycenterOrganizationsSourcesFindingsCreate_589174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a finding. The corresponding source must exist for finding creation
  ## to succeed.
  ## 
  let valid = call_589191.validator(path, query, header, formData, body)
  let scheme = call_589191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589191.url(scheme.get, call_589191.host, call_589191.base,
                         call_589191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589191, url, valid)

proc call*(call_589192: Call_SecuritycenterOrganizationsSourcesFindingsCreate_589174;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; findingId: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsSourcesFindingsCreate
  ## Creates a finding. The corresponding source must exist for finding creation
  ## to succeed.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   findingId: string
  ##            : Required. Unique identifier provided by the client within the parent scope.
  ## It must be alphanumeric and less than or equal to 32 characters and
  ## greater than 0 characters in length.
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
  ##         : Required. Resource name of the new finding's parent. Its format should be
  ## "organizations/[organization_id]/sources/[source_id]".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589193 = newJObject()
  var query_589194 = newJObject()
  var body_589195 = newJObject()
  add(query_589194, "upload_protocol", newJString(uploadProtocol))
  add(query_589194, "fields", newJString(fields))
  add(query_589194, "quotaUser", newJString(quotaUser))
  add(query_589194, "findingId", newJString(findingId))
  add(query_589194, "alt", newJString(alt))
  add(query_589194, "oauth_token", newJString(oauthToken))
  add(query_589194, "callback", newJString(callback))
  add(query_589194, "access_token", newJString(accessToken))
  add(query_589194, "uploadType", newJString(uploadType))
  add(path_589193, "parent", newJString(parent))
  add(query_589194, "key", newJString(key))
  add(query_589194, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589195 = body
  add(query_589194, "prettyPrint", newJBool(prettyPrint))
  result = call_589192.call(path_589193, query_589194, nil, nil, body_589195)

var securitycenterOrganizationsSourcesFindingsCreate* = Call_SecuritycenterOrganizationsSourcesFindingsCreate_589174(
    name: "securitycenterOrganizationsSourcesFindingsCreate",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{parent}/findings",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsCreate_589175,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsCreate_589176,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsList_589148 = ref object of OpenApiRestCall_588441
proc url_SecuritycenterOrganizationsSourcesFindingsList_589150(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/findings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesFindingsList_589149(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists an organization or source's findings.
  ## 
  ## To list across all sources provide a `-` as the source id.
  ## Example: /v1/organizations/123/sources/-/findings
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Name of the source the findings belong to. Its format is
  ## "organizations/[organization_id]/sources/[source_id]". To list across all
  ## sources provide a source_id of `-`. For example:
  ## organizations/123/sources/-
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589151 = path.getOrDefault("parent")
  valid_589151 = validateParameter(valid_589151, JString, required = true,
                                 default = nil)
  if valid_589151 != nil:
    section.add "parent", valid_589151
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value returned by the last `ListFindingsResponse`; indicates
  ## that this is a continuation of a prior `ListFindings` call, and
  ## that the system should return the next page of data.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   readTime: JString
  ##           : Time used as a reference point when filtering findings. The filter is
  ## limited to findings existing at the supplied time and their values are
  ## those at that specific time. Absence of this field will default to the
  ## API's version of NOW.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Expression that defines what fields and order to use for sorting. The
  ## string value should follow SQL syntax: comma separated list of fields. For
  ## example: "name,resource_properties.a_property". The default sorting order
  ## is ascending. To specify descending order for a field, a suffix " desc"
  ## should be appended to the field name. For example: "name
  ## desc,source_properties.a_property". Redundant space characters in the
  ## syntax are insignificant. "name desc,source_properties.a_property" and "
  ## name     desc  ,   source_properties.a_property  " are equivalent.
  ## 
  ## The following fields are supported:
  ## name
  ## parent
  ## state
  ## category
  ## resource_name
  ## event_time
  ## source_properties
  ## security_marks.marks
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fieldMask: JString
  ##            : Optional. A field mask to specify the Finding fields to be listed in the response.
  ## An empty field mask will list all fields.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   compareDuration: JString
  ##                  : When compare_duration is set, the ListFindingsResult's "state_change"
  ## attribute is updated to indicate whether the finding had its state changed,
  ## the finding's state remained unchanged, or if the finding was added in any
  ## state during the compare_duration period of time that precedes the
  ## read_time. This is the time between (read_time - compare_duration) and
  ## read_time.
  ## 
  ## The state_change value is derived based on the presence and state of the
  ## finding at the two points in time. Intermediate state changes between the
  ## two times don't affect the result. For example, the results aren't affected
  ## if the finding is made inactive and then active again.
  ## 
  ## Possible "state_change" values when compare_duration is specified:
  ## 
  ## * "CHANGED":   indicates that the finding was present at the start of
  ##                  compare_duration, but changed its state at read_time.
  ## * "UNCHANGED": indicates that the finding was present at the start of
  ##                  compare_duration and did not change state at read_time.
  ## * "ADDED":     indicates that the finding was not present at the start
  ##                  of compare_duration, but was present at read_time.
  ## 
  ## If compare_duration is not specified, then the only possible state_change
  ## is "UNUSED", which will be the state_change set for all findings present at
  ## read_time.
  ##   pageSize: JInt
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Expression that defines the filter to apply across findings.
  ## The expression is a list of one or more restrictions combined via logical
  ## operators `AND` and `OR`.
  ## Parentheses are supported, and `OR` has higher precedence than `AND`.
  ## 
  ## Restrictions have the form `<field> <operator> <value>` and may have a `-`
  ## character in front of them to indicate negation. Examples include:
  ## 
  ##  * name
  ##  * source_properties.a_property
  ##  * security_marks.marks.marka
  ## 
  ## The supported operators are:
  ## 
  ## * `=` for all value types.
  ## * `>`, `<`, `>=`, `<=` for integer values.
  ## * `:`, meaning substring matching, for strings.
  ## 
  ## The supported value types are:
  ## 
  ## * string literals in quotes.
  ## * integer literals without quotes.
  ## * boolean literals `true` and `false` without quotes.
  ## 
  ## The following field and operator combinations are supported:
  ## 
  ## name: `=`
  ## parent: `=`, `:`
  ## resource_name: `=`, `:`
  ## state: `=`, `:`
  ## category: `=`, `:`
  ## external_uri: `=`, `:`
  ## event_time: `=`, `>`, `<`, `>=`, `<=`
  ## 
  ##   Usage: This should be milliseconds since epoch or an RFC3339 string.
  ##   Examples:
  ##     "event_time = \"2019-06-10T16:07:18-07:00\""
  ##     "event_time = 1560208038000"
  ## 
  ## security_marks.marks: `=`, `:`
  ## source_properties: `=`, `:`, `>`, `<`, `>=`, `<=`
  ## 
  ## For example, `source_properties.size = 100` is a valid filter string.
  section = newJObject()
  var valid_589152 = query.getOrDefault("upload_protocol")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "upload_protocol", valid_589152
  var valid_589153 = query.getOrDefault("fields")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "fields", valid_589153
  var valid_589154 = query.getOrDefault("pageToken")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "pageToken", valid_589154
  var valid_589155 = query.getOrDefault("quotaUser")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "quotaUser", valid_589155
  var valid_589156 = query.getOrDefault("alt")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = newJString("json"))
  if valid_589156 != nil:
    section.add "alt", valid_589156
  var valid_589157 = query.getOrDefault("readTime")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "readTime", valid_589157
  var valid_589158 = query.getOrDefault("oauth_token")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "oauth_token", valid_589158
  var valid_589159 = query.getOrDefault("callback")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "callback", valid_589159
  var valid_589160 = query.getOrDefault("access_token")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "access_token", valid_589160
  var valid_589161 = query.getOrDefault("uploadType")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "uploadType", valid_589161
  var valid_589162 = query.getOrDefault("orderBy")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "orderBy", valid_589162
  var valid_589163 = query.getOrDefault("key")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "key", valid_589163
  var valid_589164 = query.getOrDefault("fieldMask")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "fieldMask", valid_589164
  var valid_589165 = query.getOrDefault("$.xgafv")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = newJString("1"))
  if valid_589165 != nil:
    section.add "$.xgafv", valid_589165
  var valid_589166 = query.getOrDefault("compareDuration")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "compareDuration", valid_589166
  var valid_589167 = query.getOrDefault("pageSize")
  valid_589167 = validateParameter(valid_589167, JInt, required = false, default = nil)
  if valid_589167 != nil:
    section.add "pageSize", valid_589167
  var valid_589168 = query.getOrDefault("prettyPrint")
  valid_589168 = validateParameter(valid_589168, JBool, required = false,
                                 default = newJBool(true))
  if valid_589168 != nil:
    section.add "prettyPrint", valid_589168
  var valid_589169 = query.getOrDefault("filter")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "filter", valid_589169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589170: Call_SecuritycenterOrganizationsSourcesFindingsList_589148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists an organization or source's findings.
  ## 
  ## To list across all sources provide a `-` as the source id.
  ## Example: /v1/organizations/123/sources/-/findings
  ## 
  let valid = call_589170.validator(path, query, header, formData, body)
  let scheme = call_589170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589170.url(scheme.get, call_589170.host, call_589170.base,
                         call_589170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589170, url, valid)

proc call*(call_589171: Call_SecuritycenterOrganizationsSourcesFindingsList_589148;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          readTime: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; orderBy: string = "";
          key: string = ""; fieldMask: string = ""; Xgafv: string = "1";
          compareDuration: string = ""; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## securitycenterOrganizationsSourcesFindingsList
  ## Lists an organization or source's findings.
  ## 
  ## To list across all sources provide a `-` as the source id.
  ## Example: /v1/organizations/123/sources/-/findings
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last `ListFindingsResponse`; indicates
  ## that this is a continuation of a prior `ListFindings` call, and
  ## that the system should return the next page of data.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   readTime: string
  ##           : Time used as a reference point when filtering findings. The filter is
  ## limited to findings existing at the supplied time and their values are
  ## those at that specific time. Absence of this field will default to the
  ## API's version of NOW.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. Name of the source the findings belong to. Its format is
  ## "organizations/[organization_id]/sources/[source_id]". To list across all
  ## sources provide a source_id of `-`. For example:
  ## organizations/123/sources/-
  ##   orderBy: string
  ##          : Expression that defines what fields and order to use for sorting. The
  ## string value should follow SQL syntax: comma separated list of fields. For
  ## example: "name,resource_properties.a_property". The default sorting order
  ## is ascending. To specify descending order for a field, a suffix " desc"
  ## should be appended to the field name. For example: "name
  ## desc,source_properties.a_property". Redundant space characters in the
  ## syntax are insignificant. "name desc,source_properties.a_property" and "
  ## name     desc  ,   source_properties.a_property  " are equivalent.
  ## 
  ## The following fields are supported:
  ## name
  ## parent
  ## state
  ## category
  ## resource_name
  ## event_time
  ## source_properties
  ## security_marks.marks
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fieldMask: string
  ##            : Optional. A field mask to specify the Finding fields to be listed in the response.
  ## An empty field mask will list all fields.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   compareDuration: string
  ##                  : When compare_duration is set, the ListFindingsResult's "state_change"
  ## attribute is updated to indicate whether the finding had its state changed,
  ## the finding's state remained unchanged, or if the finding was added in any
  ## state during the compare_duration period of time that precedes the
  ## read_time. This is the time between (read_time - compare_duration) and
  ## read_time.
  ## 
  ## The state_change value is derived based on the presence and state of the
  ## finding at the two points in time. Intermediate state changes between the
  ## two times don't affect the result. For example, the results aren't affected
  ## if the finding is made inactive and then active again.
  ## 
  ## Possible "state_change" values when compare_duration is specified:
  ## 
  ## * "CHANGED":   indicates that the finding was present at the start of
  ##                  compare_duration, but changed its state at read_time.
  ## * "UNCHANGED": indicates that the finding was present at the start of
  ##                  compare_duration and did not change state at read_time.
  ## * "ADDED":     indicates that the finding was not present at the start
  ##                  of compare_duration, but was present at read_time.
  ## 
  ## If compare_duration is not specified, then the only possible state_change
  ## is "UNUSED", which will be the state_change set for all findings present at
  ## read_time.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Expression that defines the filter to apply across findings.
  ## The expression is a list of one or more restrictions combined via logical
  ## operators `AND` and `OR`.
  ## Parentheses are supported, and `OR` has higher precedence than `AND`.
  ## 
  ## Restrictions have the form `<field> <operator> <value>` and may have a `-`
  ## character in front of them to indicate negation. Examples include:
  ## 
  ##  * name
  ##  * source_properties.a_property
  ##  * security_marks.marks.marka
  ## 
  ## The supported operators are:
  ## 
  ## * `=` for all value types.
  ## * `>`, `<`, `>=`, `<=` for integer values.
  ## * `:`, meaning substring matching, for strings.
  ## 
  ## The supported value types are:
  ## 
  ## * string literals in quotes.
  ## * integer literals without quotes.
  ## * boolean literals `true` and `false` without quotes.
  ## 
  ## The following field and operator combinations are supported:
  ## 
  ## name: `=`
  ## parent: `=`, `:`
  ## resource_name: `=`, `:`
  ## state: `=`, `:`
  ## category: `=`, `:`
  ## external_uri: `=`, `:`
  ## event_time: `=`, `>`, `<`, `>=`, `<=`
  ## 
  ##   Usage: This should be milliseconds since epoch or an RFC3339 string.
  ##   Examples:
  ##     "event_time = \"2019-06-10T16:07:18-07:00\""
  ##     "event_time = 1560208038000"
  ## 
  ## security_marks.marks: `=`, `:`
  ## source_properties: `=`, `:`, `>`, `<`, `>=`, `<=`
  ## 
  ## For example, `source_properties.size = 100` is a valid filter string.
  var path_589172 = newJObject()
  var query_589173 = newJObject()
  add(query_589173, "upload_protocol", newJString(uploadProtocol))
  add(query_589173, "fields", newJString(fields))
  add(query_589173, "pageToken", newJString(pageToken))
  add(query_589173, "quotaUser", newJString(quotaUser))
  add(query_589173, "alt", newJString(alt))
  add(query_589173, "readTime", newJString(readTime))
  add(query_589173, "oauth_token", newJString(oauthToken))
  add(query_589173, "callback", newJString(callback))
  add(query_589173, "access_token", newJString(accessToken))
  add(query_589173, "uploadType", newJString(uploadType))
  add(path_589172, "parent", newJString(parent))
  add(query_589173, "orderBy", newJString(orderBy))
  add(query_589173, "key", newJString(key))
  add(query_589173, "fieldMask", newJString(fieldMask))
  add(query_589173, "$.xgafv", newJString(Xgafv))
  add(query_589173, "compareDuration", newJString(compareDuration))
  add(query_589173, "pageSize", newJInt(pageSize))
  add(query_589173, "prettyPrint", newJBool(prettyPrint))
  add(query_589173, "filter", newJString(filter))
  result = call_589171.call(path_589172, query_589173, nil, nil, nil)

var securitycenterOrganizationsSourcesFindingsList* = Call_SecuritycenterOrganizationsSourcesFindingsList_589148(
    name: "securitycenterOrganizationsSourcesFindingsList",
    meth: HttpMethod.HttpGet, host: "securitycenter.googleapis.com",
    route: "/v1/{parent}/findings",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsList_589149,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsList_589150,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsGroup_589196 = ref object of OpenApiRestCall_588441
proc url_SecuritycenterOrganizationsSourcesFindingsGroup_589198(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/findings:group")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesFindingsGroup_589197(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Filters an organization or source's findings and  groups them by their
  ## specified properties.
  ## 
  ## To group across all sources provide a `-` as the source id.
  ## Example: /v1/organizations/123/sources/-/findings
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Name of the source to groupBy. Its format is
  ## "organizations/[organization_id]/sources/[source_id]". To groupBy across
  ## all sources provide a source_id of `-`. For example:
  ## organizations/123/sources/-
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589199 = path.getOrDefault("parent")
  valid_589199 = validateParameter(valid_589199, JString, required = true,
                                 default = nil)
  if valid_589199 != nil:
    section.add "parent", valid_589199
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
  var valid_589200 = query.getOrDefault("upload_protocol")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "upload_protocol", valid_589200
  var valid_589201 = query.getOrDefault("fields")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "fields", valid_589201
  var valid_589202 = query.getOrDefault("quotaUser")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "quotaUser", valid_589202
  var valid_589203 = query.getOrDefault("alt")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = newJString("json"))
  if valid_589203 != nil:
    section.add "alt", valid_589203
  var valid_589204 = query.getOrDefault("oauth_token")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "oauth_token", valid_589204
  var valid_589205 = query.getOrDefault("callback")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "callback", valid_589205
  var valid_589206 = query.getOrDefault("access_token")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "access_token", valid_589206
  var valid_589207 = query.getOrDefault("uploadType")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "uploadType", valid_589207
  var valid_589208 = query.getOrDefault("key")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "key", valid_589208
  var valid_589209 = query.getOrDefault("$.xgafv")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = newJString("1"))
  if valid_589209 != nil:
    section.add "$.xgafv", valid_589209
  var valid_589210 = query.getOrDefault("prettyPrint")
  valid_589210 = validateParameter(valid_589210, JBool, required = false,
                                 default = newJBool(true))
  if valid_589210 != nil:
    section.add "prettyPrint", valid_589210
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

proc call*(call_589212: Call_SecuritycenterOrganizationsSourcesFindingsGroup_589196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Filters an organization or source's findings and  groups them by their
  ## specified properties.
  ## 
  ## To group across all sources provide a `-` as the source id.
  ## Example: /v1/organizations/123/sources/-/findings
  ## 
  let valid = call_589212.validator(path, query, header, formData, body)
  let scheme = call_589212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589212.url(scheme.get, call_589212.host, call_589212.base,
                         call_589212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589212, url, valid)

proc call*(call_589213: Call_SecuritycenterOrganizationsSourcesFindingsGroup_589196;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsSourcesFindingsGroup
  ## Filters an organization or source's findings and  groups them by their
  ## specified properties.
  ## 
  ## To group across all sources provide a `-` as the source id.
  ## Example: /v1/organizations/123/sources/-/findings
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
  ##         : Required. Name of the source to groupBy. Its format is
  ## "organizations/[organization_id]/sources/[source_id]". To groupBy across
  ## all sources provide a source_id of `-`. For example:
  ## organizations/123/sources/-
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589214 = newJObject()
  var query_589215 = newJObject()
  var body_589216 = newJObject()
  add(query_589215, "upload_protocol", newJString(uploadProtocol))
  add(query_589215, "fields", newJString(fields))
  add(query_589215, "quotaUser", newJString(quotaUser))
  add(query_589215, "alt", newJString(alt))
  add(query_589215, "oauth_token", newJString(oauthToken))
  add(query_589215, "callback", newJString(callback))
  add(query_589215, "access_token", newJString(accessToken))
  add(query_589215, "uploadType", newJString(uploadType))
  add(path_589214, "parent", newJString(parent))
  add(query_589215, "key", newJString(key))
  add(query_589215, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589216 = body
  add(query_589215, "prettyPrint", newJBool(prettyPrint))
  result = call_589213.call(path_589214, query_589215, nil, nil, body_589216)

var securitycenterOrganizationsSourcesFindingsGroup* = Call_SecuritycenterOrganizationsSourcesFindingsGroup_589196(
    name: "securitycenterOrganizationsSourcesFindingsGroup",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{parent}/findings:group",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsGroup_589197,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsGroup_589198,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesCreate_589238 = ref object of OpenApiRestCall_588441
proc url_SecuritycenterOrganizationsSourcesCreate_589240(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/sources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesCreate_589239(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Resource name of the new source's parent. Its format should be
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589241 = path.getOrDefault("parent")
  valid_589241 = validateParameter(valid_589241, JString, required = true,
                                 default = nil)
  if valid_589241 != nil:
    section.add "parent", valid_589241
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
  var valid_589242 = query.getOrDefault("upload_protocol")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "upload_protocol", valid_589242
  var valid_589243 = query.getOrDefault("fields")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "fields", valid_589243
  var valid_589244 = query.getOrDefault("quotaUser")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "quotaUser", valid_589244
  var valid_589245 = query.getOrDefault("alt")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = newJString("json"))
  if valid_589245 != nil:
    section.add "alt", valid_589245
  var valid_589246 = query.getOrDefault("oauth_token")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "oauth_token", valid_589246
  var valid_589247 = query.getOrDefault("callback")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "callback", valid_589247
  var valid_589248 = query.getOrDefault("access_token")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "access_token", valid_589248
  var valid_589249 = query.getOrDefault("uploadType")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "uploadType", valid_589249
  var valid_589250 = query.getOrDefault("key")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "key", valid_589250
  var valid_589251 = query.getOrDefault("$.xgafv")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = newJString("1"))
  if valid_589251 != nil:
    section.add "$.xgafv", valid_589251
  var valid_589252 = query.getOrDefault("prettyPrint")
  valid_589252 = validateParameter(valid_589252, JBool, required = false,
                                 default = newJBool(true))
  if valid_589252 != nil:
    section.add "prettyPrint", valid_589252
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

proc call*(call_589254: Call_SecuritycenterOrganizationsSourcesCreate_589238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a source.
  ## 
  let valid = call_589254.validator(path, query, header, formData, body)
  let scheme = call_589254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589254.url(scheme.get, call_589254.host, call_589254.base,
                         call_589254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589254, url, valid)

proc call*(call_589255: Call_SecuritycenterOrganizationsSourcesCreate_589238;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsSourcesCreate
  ## Creates a source.
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
  ##         : Required. Resource name of the new source's parent. Its format should be
  ## "organizations/[organization_id]".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589256 = newJObject()
  var query_589257 = newJObject()
  var body_589258 = newJObject()
  add(query_589257, "upload_protocol", newJString(uploadProtocol))
  add(query_589257, "fields", newJString(fields))
  add(query_589257, "quotaUser", newJString(quotaUser))
  add(query_589257, "alt", newJString(alt))
  add(query_589257, "oauth_token", newJString(oauthToken))
  add(query_589257, "callback", newJString(callback))
  add(query_589257, "access_token", newJString(accessToken))
  add(query_589257, "uploadType", newJString(uploadType))
  add(path_589256, "parent", newJString(parent))
  add(query_589257, "key", newJString(key))
  add(query_589257, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589258 = body
  add(query_589257, "prettyPrint", newJBool(prettyPrint))
  result = call_589255.call(path_589256, query_589257, nil, nil, body_589258)

var securitycenterOrganizationsSourcesCreate* = Call_SecuritycenterOrganizationsSourcesCreate_589238(
    name: "securitycenterOrganizationsSourcesCreate", meth: HttpMethod.HttpPost,
    host: "securitycenter.googleapis.com", route: "/v1/{parent}/sources",
    validator: validate_SecuritycenterOrganizationsSourcesCreate_589239,
    base: "/", url: url_SecuritycenterOrganizationsSourcesCreate_589240,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesList_589217 = ref object of OpenApiRestCall_588441
proc url_SecuritycenterOrganizationsSourcesList_589219(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/sources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesList_589218(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all sources belonging to an organization.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Resource name of the parent of sources to list. Its format should be
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589220 = path.getOrDefault("parent")
  valid_589220 = validateParameter(valid_589220, JString, required = true,
                                 default = nil)
  if valid_589220 != nil:
    section.add "parent", valid_589220
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value returned by the last `ListSourcesResponse`; indicates
  ## that this is a continuation of a prior `ListSources` call, and
  ## that the system should return the next page of data.
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
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589221 = query.getOrDefault("upload_protocol")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "upload_protocol", valid_589221
  var valid_589222 = query.getOrDefault("fields")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "fields", valid_589222
  var valid_589223 = query.getOrDefault("pageToken")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "pageToken", valid_589223
  var valid_589224 = query.getOrDefault("quotaUser")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "quotaUser", valid_589224
  var valid_589225 = query.getOrDefault("alt")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = newJString("json"))
  if valid_589225 != nil:
    section.add "alt", valid_589225
  var valid_589226 = query.getOrDefault("oauth_token")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "oauth_token", valid_589226
  var valid_589227 = query.getOrDefault("callback")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "callback", valid_589227
  var valid_589228 = query.getOrDefault("access_token")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "access_token", valid_589228
  var valid_589229 = query.getOrDefault("uploadType")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "uploadType", valid_589229
  var valid_589230 = query.getOrDefault("key")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "key", valid_589230
  var valid_589231 = query.getOrDefault("$.xgafv")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = newJString("1"))
  if valid_589231 != nil:
    section.add "$.xgafv", valid_589231
  var valid_589232 = query.getOrDefault("pageSize")
  valid_589232 = validateParameter(valid_589232, JInt, required = false, default = nil)
  if valid_589232 != nil:
    section.add "pageSize", valid_589232
  var valid_589233 = query.getOrDefault("prettyPrint")
  valid_589233 = validateParameter(valid_589233, JBool, required = false,
                                 default = newJBool(true))
  if valid_589233 != nil:
    section.add "prettyPrint", valid_589233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589234: Call_SecuritycenterOrganizationsSourcesList_589217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all sources belonging to an organization.
  ## 
  let valid = call_589234.validator(path, query, header, formData, body)
  let scheme = call_589234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589234.url(scheme.get, call_589234.host, call_589234.base,
                         call_589234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589234, url, valid)

proc call*(call_589235: Call_SecuritycenterOrganizationsSourcesList_589217;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsSourcesList
  ## Lists all sources belonging to an organization.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last `ListSourcesResponse`; indicates
  ## that this is a continuation of a prior `ListSources` call, and
  ## that the system should return the next page of data.
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
  ##         : Required. Resource name of the parent of sources to list. Its format should be
  ## "organizations/[organization_id]".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589236 = newJObject()
  var query_589237 = newJObject()
  add(query_589237, "upload_protocol", newJString(uploadProtocol))
  add(query_589237, "fields", newJString(fields))
  add(query_589237, "pageToken", newJString(pageToken))
  add(query_589237, "quotaUser", newJString(quotaUser))
  add(query_589237, "alt", newJString(alt))
  add(query_589237, "oauth_token", newJString(oauthToken))
  add(query_589237, "callback", newJString(callback))
  add(query_589237, "access_token", newJString(accessToken))
  add(query_589237, "uploadType", newJString(uploadType))
  add(path_589236, "parent", newJString(parent))
  add(query_589237, "key", newJString(key))
  add(query_589237, "$.xgafv", newJString(Xgafv))
  add(query_589237, "pageSize", newJInt(pageSize))
  add(query_589237, "prettyPrint", newJBool(prettyPrint))
  result = call_589235.call(path_589236, query_589237, nil, nil, nil)

var securitycenterOrganizationsSourcesList* = Call_SecuritycenterOrganizationsSourcesList_589217(
    name: "securitycenterOrganizationsSourcesList", meth: HttpMethod.HttpGet,
    host: "securitycenter.googleapis.com", route: "/v1/{parent}/sources",
    validator: validate_SecuritycenterOrganizationsSourcesList_589218, base: "/",
    url: url_SecuritycenterOrganizationsSourcesList_589219,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesGetIamPolicy_589259 = ref object of OpenApiRestCall_588441
proc url_SecuritycenterOrganizationsSourcesGetIamPolicy_589261(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesGetIamPolicy_589260(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy on the specified Source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589262 = path.getOrDefault("resource")
  valid_589262 = validateParameter(valid_589262, JString, required = true,
                                 default = nil)
  if valid_589262 != nil:
    section.add "resource", valid_589262
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
  var valid_589263 = query.getOrDefault("upload_protocol")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "upload_protocol", valid_589263
  var valid_589264 = query.getOrDefault("fields")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "fields", valid_589264
  var valid_589265 = query.getOrDefault("quotaUser")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "quotaUser", valid_589265
  var valid_589266 = query.getOrDefault("alt")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = newJString("json"))
  if valid_589266 != nil:
    section.add "alt", valid_589266
  var valid_589267 = query.getOrDefault("oauth_token")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "oauth_token", valid_589267
  var valid_589268 = query.getOrDefault("callback")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "callback", valid_589268
  var valid_589269 = query.getOrDefault("access_token")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "access_token", valid_589269
  var valid_589270 = query.getOrDefault("uploadType")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "uploadType", valid_589270
  var valid_589271 = query.getOrDefault("key")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "key", valid_589271
  var valid_589272 = query.getOrDefault("$.xgafv")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = newJString("1"))
  if valid_589272 != nil:
    section.add "$.xgafv", valid_589272
  var valid_589273 = query.getOrDefault("prettyPrint")
  valid_589273 = validateParameter(valid_589273, JBool, required = false,
                                 default = newJBool(true))
  if valid_589273 != nil:
    section.add "prettyPrint", valid_589273
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

proc call*(call_589275: Call_SecuritycenterOrganizationsSourcesGetIamPolicy_589259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy on the specified Source.
  ## 
  let valid = call_589275.validator(path, query, header, formData, body)
  let scheme = call_589275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589275.url(scheme.get, call_589275.host, call_589275.base,
                         call_589275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589275, url, valid)

proc call*(call_589276: Call_SecuritycenterOrganizationsSourcesGetIamPolicy_589259;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsSourcesGetIamPolicy
  ## Gets the access control policy on the specified Source.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589277 = newJObject()
  var query_589278 = newJObject()
  var body_589279 = newJObject()
  add(query_589278, "upload_protocol", newJString(uploadProtocol))
  add(query_589278, "fields", newJString(fields))
  add(query_589278, "quotaUser", newJString(quotaUser))
  add(query_589278, "alt", newJString(alt))
  add(query_589278, "oauth_token", newJString(oauthToken))
  add(query_589278, "callback", newJString(callback))
  add(query_589278, "access_token", newJString(accessToken))
  add(query_589278, "uploadType", newJString(uploadType))
  add(query_589278, "key", newJString(key))
  add(query_589278, "$.xgafv", newJString(Xgafv))
  add(path_589277, "resource", newJString(resource))
  if body != nil:
    body_589279 = body
  add(query_589278, "prettyPrint", newJBool(prettyPrint))
  result = call_589276.call(path_589277, query_589278, nil, nil, body_589279)

var securitycenterOrganizationsSourcesGetIamPolicy* = Call_SecuritycenterOrganizationsSourcesGetIamPolicy_589259(
    name: "securitycenterOrganizationsSourcesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_SecuritycenterOrganizationsSourcesGetIamPolicy_589260,
    base: "/", url: url_SecuritycenterOrganizationsSourcesGetIamPolicy_589261,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesSetIamPolicy_589280 = ref object of OpenApiRestCall_588441
proc url_SecuritycenterOrganizationsSourcesSetIamPolicy_589282(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesSetIamPolicy_589281(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified Source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589283 = path.getOrDefault("resource")
  valid_589283 = validateParameter(valid_589283, JString, required = true,
                                 default = nil)
  if valid_589283 != nil:
    section.add "resource", valid_589283
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
  var valid_589284 = query.getOrDefault("upload_protocol")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "upload_protocol", valid_589284
  var valid_589285 = query.getOrDefault("fields")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "fields", valid_589285
  var valid_589286 = query.getOrDefault("quotaUser")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "quotaUser", valid_589286
  var valid_589287 = query.getOrDefault("alt")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = newJString("json"))
  if valid_589287 != nil:
    section.add "alt", valid_589287
  var valid_589288 = query.getOrDefault("oauth_token")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "oauth_token", valid_589288
  var valid_589289 = query.getOrDefault("callback")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "callback", valid_589289
  var valid_589290 = query.getOrDefault("access_token")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "access_token", valid_589290
  var valid_589291 = query.getOrDefault("uploadType")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "uploadType", valid_589291
  var valid_589292 = query.getOrDefault("key")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "key", valid_589292
  var valid_589293 = query.getOrDefault("$.xgafv")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = newJString("1"))
  if valid_589293 != nil:
    section.add "$.xgafv", valid_589293
  var valid_589294 = query.getOrDefault("prettyPrint")
  valid_589294 = validateParameter(valid_589294, JBool, required = false,
                                 default = newJBool(true))
  if valid_589294 != nil:
    section.add "prettyPrint", valid_589294
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

proc call*(call_589296: Call_SecuritycenterOrganizationsSourcesSetIamPolicy_589280;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified Source.
  ## 
  let valid = call_589296.validator(path, query, header, formData, body)
  let scheme = call_589296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589296.url(scheme.get, call_589296.host, call_589296.base,
                         call_589296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589296, url, valid)

proc call*(call_589297: Call_SecuritycenterOrganizationsSourcesSetIamPolicy_589280;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsSourcesSetIamPolicy
  ## Sets the access control policy on the specified Source.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589298 = newJObject()
  var query_589299 = newJObject()
  var body_589300 = newJObject()
  add(query_589299, "upload_protocol", newJString(uploadProtocol))
  add(query_589299, "fields", newJString(fields))
  add(query_589299, "quotaUser", newJString(quotaUser))
  add(query_589299, "alt", newJString(alt))
  add(query_589299, "oauth_token", newJString(oauthToken))
  add(query_589299, "callback", newJString(callback))
  add(query_589299, "access_token", newJString(accessToken))
  add(query_589299, "uploadType", newJString(uploadType))
  add(query_589299, "key", newJString(key))
  add(query_589299, "$.xgafv", newJString(Xgafv))
  add(path_589298, "resource", newJString(resource))
  if body != nil:
    body_589300 = body
  add(query_589299, "prettyPrint", newJBool(prettyPrint))
  result = call_589297.call(path_589298, query_589299, nil, nil, body_589300)

var securitycenterOrganizationsSourcesSetIamPolicy* = Call_SecuritycenterOrganizationsSourcesSetIamPolicy_589280(
    name: "securitycenterOrganizationsSourcesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_SecuritycenterOrganizationsSourcesSetIamPolicy_589281,
    base: "/", url: url_SecuritycenterOrganizationsSourcesSetIamPolicy_589282,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesTestIamPermissions_589301 = ref object of OpenApiRestCall_588441
proc url_SecuritycenterOrganizationsSourcesTestIamPermissions_589303(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesTestIamPermissions_589302(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the permissions that a caller has on the specified source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_589304 = path.getOrDefault("resource")
  valid_589304 = validateParameter(valid_589304, JString, required = true,
                                 default = nil)
  if valid_589304 != nil:
    section.add "resource", valid_589304
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
  var valid_589305 = query.getOrDefault("upload_protocol")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "upload_protocol", valid_589305
  var valid_589306 = query.getOrDefault("fields")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "fields", valid_589306
  var valid_589307 = query.getOrDefault("quotaUser")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "quotaUser", valid_589307
  var valid_589308 = query.getOrDefault("alt")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = newJString("json"))
  if valid_589308 != nil:
    section.add "alt", valid_589308
  var valid_589309 = query.getOrDefault("oauth_token")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "oauth_token", valid_589309
  var valid_589310 = query.getOrDefault("callback")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "callback", valid_589310
  var valid_589311 = query.getOrDefault("access_token")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "access_token", valid_589311
  var valid_589312 = query.getOrDefault("uploadType")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "uploadType", valid_589312
  var valid_589313 = query.getOrDefault("key")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "key", valid_589313
  var valid_589314 = query.getOrDefault("$.xgafv")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = newJString("1"))
  if valid_589314 != nil:
    section.add "$.xgafv", valid_589314
  var valid_589315 = query.getOrDefault("prettyPrint")
  valid_589315 = validateParameter(valid_589315, JBool, required = false,
                                 default = newJBool(true))
  if valid_589315 != nil:
    section.add "prettyPrint", valid_589315
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

proc call*(call_589317: Call_SecuritycenterOrganizationsSourcesTestIamPermissions_589301;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the permissions that a caller has on the specified source.
  ## 
  let valid = call_589317.validator(path, query, header, formData, body)
  let scheme = call_589317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589317.url(scheme.get, call_589317.host, call_589317.base,
                         call_589317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589317, url, valid)

proc call*(call_589318: Call_SecuritycenterOrganizationsSourcesTestIamPermissions_589301;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsSourcesTestIamPermissions
  ## Returns the permissions that a caller has on the specified source.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589319 = newJObject()
  var query_589320 = newJObject()
  var body_589321 = newJObject()
  add(query_589320, "upload_protocol", newJString(uploadProtocol))
  add(query_589320, "fields", newJString(fields))
  add(query_589320, "quotaUser", newJString(quotaUser))
  add(query_589320, "alt", newJString(alt))
  add(query_589320, "oauth_token", newJString(oauthToken))
  add(query_589320, "callback", newJString(callback))
  add(query_589320, "access_token", newJString(accessToken))
  add(query_589320, "uploadType", newJString(uploadType))
  add(query_589320, "key", newJString(key))
  add(query_589320, "$.xgafv", newJString(Xgafv))
  add(path_589319, "resource", newJString(resource))
  if body != nil:
    body_589321 = body
  add(query_589320, "prettyPrint", newJBool(prettyPrint))
  result = call_589318.call(path_589319, query_589320, nil, nil, body_589321)

var securitycenterOrganizationsSourcesTestIamPermissions* = Call_SecuritycenterOrganizationsSourcesTestIamPermissions_589301(
    name: "securitycenterOrganizationsSourcesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_SecuritycenterOrganizationsSourcesTestIamPermissions_589302,
    base: "/", url: url_SecuritycenterOrganizationsSourcesTestIamPermissions_589303,
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
