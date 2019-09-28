
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
  gcpServiceName = "securitycenter"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SecuritycenterOrganizationsOperationsGet_579677 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsOperationsGet_579679(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsOperationsGet_579678(path: JsonNode;
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
  var valid_579805 = path.getOrDefault("name")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "name", valid_579805
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
  var valid_579806 = query.getOrDefault("upload_protocol")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "upload_protocol", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("quotaUser")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "quotaUser", valid_579808
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("oauth_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "oauth_token", valid_579823
  var valid_579824 = query.getOrDefault("callback")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "callback", valid_579824
  var valid_579825 = query.getOrDefault("access_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "access_token", valid_579825
  var valid_579826 = query.getOrDefault("uploadType")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "uploadType", valid_579826
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("$.xgafv")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = newJString("1"))
  if valid_579828 != nil:
    section.add "$.xgafv", valid_579828
  var valid_579829 = query.getOrDefault("prettyPrint")
  valid_579829 = validateParameter(valid_579829, JBool, required = false,
                                 default = newJBool(true))
  if valid_579829 != nil:
    section.add "prettyPrint", valid_579829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579852: Call_SecuritycenterOrganizationsOperationsGet_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_579852.validator(path, query, header, formData, body)
  let scheme = call_579852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579852.url(scheme.get, call_579852.host, call_579852.base,
                         call_579852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579852, url, valid)

proc call*(call_579923: Call_SecuritycenterOrganizationsOperationsGet_579677;
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
  var path_579924 = newJObject()
  var query_579926 = newJObject()
  add(query_579926, "upload_protocol", newJString(uploadProtocol))
  add(query_579926, "fields", newJString(fields))
  add(query_579926, "quotaUser", newJString(quotaUser))
  add(path_579924, "name", newJString(name))
  add(query_579926, "alt", newJString(alt))
  add(query_579926, "oauth_token", newJString(oauthToken))
  add(query_579926, "callback", newJString(callback))
  add(query_579926, "access_token", newJString(accessToken))
  add(query_579926, "uploadType", newJString(uploadType))
  add(query_579926, "key", newJString(key))
  add(query_579926, "$.xgafv", newJString(Xgafv))
  add(query_579926, "prettyPrint", newJBool(prettyPrint))
  result = call_579923.call(path_579924, query_579926, nil, nil, nil)

var securitycenterOrganizationsOperationsGet* = Call_SecuritycenterOrganizationsOperationsGet_579677(
    name: "securitycenterOrganizationsOperationsGet", meth: HttpMethod.HttpGet,
    host: "securitycenter.googleapis.com", route: "/v1/{name}",
    validator: validate_SecuritycenterOrganizationsOperationsGet_579678,
    base: "/", url: url_SecuritycenterOrganizationsOperationsGet_579679,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_579984 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_579986(
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

proc validate_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_579985(
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
  var valid_579987 = path.getOrDefault("name")
  valid_579987 = validateParameter(valid_579987, JString, required = true,
                                 default = nil)
  if valid_579987 != nil:
    section.add "name", valid_579987
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
  var valid_579988 = query.getOrDefault("upload_protocol")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "upload_protocol", valid_579988
  var valid_579989 = query.getOrDefault("fields")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "fields", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("oauth_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "oauth_token", valid_579992
  var valid_579993 = query.getOrDefault("callback")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "callback", valid_579993
  var valid_579994 = query.getOrDefault("access_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "access_token", valid_579994
  var valid_579995 = query.getOrDefault("uploadType")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "uploadType", valid_579995
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("$.xgafv")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("1"))
  if valid_579997 != nil:
    section.add "$.xgafv", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
  var valid_579999 = query.getOrDefault("startTime")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "startTime", valid_579999
  var valid_580000 = query.getOrDefault("updateMask")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "updateMask", valid_580000
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

proc call*(call_580002: Call_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_579984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates security marks.
  ## 
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_579984;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; startTime: string = ""; updateMask: string = ""): Recallable =
  ## securitycenterOrganizationsSourcesFindingsUpdateSecurityMarks
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
  var path_580004 = newJObject()
  var query_580005 = newJObject()
  var body_580006 = newJObject()
  add(query_580005, "upload_protocol", newJString(uploadProtocol))
  add(query_580005, "fields", newJString(fields))
  add(query_580005, "quotaUser", newJString(quotaUser))
  add(path_580004, "name", newJString(name))
  add(query_580005, "alt", newJString(alt))
  add(query_580005, "oauth_token", newJString(oauthToken))
  add(query_580005, "callback", newJString(callback))
  add(query_580005, "access_token", newJString(accessToken))
  add(query_580005, "uploadType", newJString(uploadType))
  add(query_580005, "key", newJString(key))
  add(query_580005, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580006 = body
  add(query_580005, "prettyPrint", newJBool(prettyPrint))
  add(query_580005, "startTime", newJString(startTime))
  add(query_580005, "updateMask", newJString(updateMask))
  result = call_580003.call(path_580004, query_580005, nil, nil, body_580006)

var securitycenterOrganizationsSourcesFindingsUpdateSecurityMarks* = Call_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_579984(
    name: "securitycenterOrganizationsSourcesFindingsUpdateSecurityMarks",
    meth: HttpMethod.HttpPatch, host: "securitycenter.googleapis.com",
    route: "/v1/{name}", validator: validate_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_579985,
    base: "/",
    url: url_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_579986,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsOperationsDelete_579965 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsOperationsDelete_579967(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsOperationsDelete_579966(path: JsonNode;
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
  var valid_579968 = path.getOrDefault("name")
  valid_579968 = validateParameter(valid_579968, JString, required = true,
                                 default = nil)
  if valid_579968 != nil:
    section.add "name", valid_579968
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
  var valid_579969 = query.getOrDefault("upload_protocol")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "upload_protocol", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("oauth_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "oauth_token", valid_579973
  var valid_579974 = query.getOrDefault("callback")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "callback", valid_579974
  var valid_579975 = query.getOrDefault("access_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "access_token", valid_579975
  var valid_579976 = query.getOrDefault("uploadType")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "uploadType", valid_579976
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("$.xgafv")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("1"))
  if valid_579978 != nil:
    section.add "$.xgafv", valid_579978
  var valid_579979 = query.getOrDefault("prettyPrint")
  valid_579979 = validateParameter(valid_579979, JBool, required = false,
                                 default = newJBool(true))
  if valid_579979 != nil:
    section.add "prettyPrint", valid_579979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579980: Call_SecuritycenterOrganizationsOperationsDelete_579965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_579980.validator(path, query, header, formData, body)
  let scheme = call_579980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579980.url(scheme.get, call_579980.host, call_579980.base,
                         call_579980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579980, url, valid)

proc call*(call_579981: Call_SecuritycenterOrganizationsOperationsDelete_579965;
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
  var path_579982 = newJObject()
  var query_579983 = newJObject()
  add(query_579983, "upload_protocol", newJString(uploadProtocol))
  add(query_579983, "fields", newJString(fields))
  add(query_579983, "quotaUser", newJString(quotaUser))
  add(path_579982, "name", newJString(name))
  add(query_579983, "alt", newJString(alt))
  add(query_579983, "oauth_token", newJString(oauthToken))
  add(query_579983, "callback", newJString(callback))
  add(query_579983, "access_token", newJString(accessToken))
  add(query_579983, "uploadType", newJString(uploadType))
  add(query_579983, "key", newJString(key))
  add(query_579983, "$.xgafv", newJString(Xgafv))
  add(query_579983, "prettyPrint", newJBool(prettyPrint))
  result = call_579981.call(path_579982, query_579983, nil, nil, nil)

var securitycenterOrganizationsOperationsDelete* = Call_SecuritycenterOrganizationsOperationsDelete_579965(
    name: "securitycenterOrganizationsOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "securitycenter.googleapis.com",
    route: "/v1/{name}",
    validator: validate_SecuritycenterOrganizationsOperationsDelete_579966,
    base: "/", url: url_SecuritycenterOrganizationsOperationsDelete_579967,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsOperationsCancel_580007 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsOperationsCancel_580009(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsOperationsCancel_580008(path: JsonNode;
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
  var valid_580010 = path.getOrDefault("name")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "name", valid_580010
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
  var valid_580011 = query.getOrDefault("upload_protocol")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "upload_protocol", valid_580011
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("oauth_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "oauth_token", valid_580015
  var valid_580016 = query.getOrDefault("callback")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "callback", valid_580016
  var valid_580017 = query.getOrDefault("access_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "access_token", valid_580017
  var valid_580018 = query.getOrDefault("uploadType")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "uploadType", valid_580018
  var valid_580019 = query.getOrDefault("key")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "key", valid_580019
  var valid_580020 = query.getOrDefault("$.xgafv")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = newJString("1"))
  if valid_580020 != nil:
    section.add "$.xgafv", valid_580020
  var valid_580021 = query.getOrDefault("prettyPrint")
  valid_580021 = validateParameter(valid_580021, JBool, required = false,
                                 default = newJBool(true))
  if valid_580021 != nil:
    section.add "prettyPrint", valid_580021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580022: Call_SecuritycenterOrganizationsOperationsCancel_580007;
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
  let valid = call_580022.validator(path, query, header, formData, body)
  let scheme = call_580022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580022.url(scheme.get, call_580022.host, call_580022.base,
                         call_580022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580022, url, valid)

proc call*(call_580023: Call_SecuritycenterOrganizationsOperationsCancel_580007;
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
  var path_580024 = newJObject()
  var query_580025 = newJObject()
  add(query_580025, "upload_protocol", newJString(uploadProtocol))
  add(query_580025, "fields", newJString(fields))
  add(query_580025, "quotaUser", newJString(quotaUser))
  add(path_580024, "name", newJString(name))
  add(query_580025, "alt", newJString(alt))
  add(query_580025, "oauth_token", newJString(oauthToken))
  add(query_580025, "callback", newJString(callback))
  add(query_580025, "access_token", newJString(accessToken))
  add(query_580025, "uploadType", newJString(uploadType))
  add(query_580025, "key", newJString(key))
  add(query_580025, "$.xgafv", newJString(Xgafv))
  add(query_580025, "prettyPrint", newJBool(prettyPrint))
  result = call_580023.call(path_580024, query_580025, nil, nil, nil)

var securitycenterOrganizationsOperationsCancel* = Call_SecuritycenterOrganizationsOperationsCancel_580007(
    name: "securitycenterOrganizationsOperationsCancel",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{name}:cancel",
    validator: validate_SecuritycenterOrganizationsOperationsCancel_580008,
    base: "/", url: url_SecuritycenterOrganizationsOperationsCancel_580009,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsSetState_580026 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesFindingsSetState_580028(
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

proc validate_SecuritycenterOrganizationsSourcesFindingsSetState_580027(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the state of a finding.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The relative resource name of the finding. See:
  ## https://cloud.google.com/apis/design/resource_names#relative_resource_name
  ## Example:
  ## "organizations/123/sources/456/finding/789".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580029 = path.getOrDefault("name")
  valid_580029 = validateParameter(valid_580029, JString, required = true,
                                 default = nil)
  if valid_580029 != nil:
    section.add "name", valid_580029
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
  var valid_580030 = query.getOrDefault("upload_protocol")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "upload_protocol", valid_580030
  var valid_580031 = query.getOrDefault("fields")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "fields", valid_580031
  var valid_580032 = query.getOrDefault("quotaUser")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "quotaUser", valid_580032
  var valid_580033 = query.getOrDefault("alt")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = newJString("json"))
  if valid_580033 != nil:
    section.add "alt", valid_580033
  var valid_580034 = query.getOrDefault("oauth_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "oauth_token", valid_580034
  var valid_580035 = query.getOrDefault("callback")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "callback", valid_580035
  var valid_580036 = query.getOrDefault("access_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "access_token", valid_580036
  var valid_580037 = query.getOrDefault("uploadType")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "uploadType", valid_580037
  var valid_580038 = query.getOrDefault("key")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "key", valid_580038
  var valid_580039 = query.getOrDefault("$.xgafv")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("1"))
  if valid_580039 != nil:
    section.add "$.xgafv", valid_580039
  var valid_580040 = query.getOrDefault("prettyPrint")
  valid_580040 = validateParameter(valid_580040, JBool, required = false,
                                 default = newJBool(true))
  if valid_580040 != nil:
    section.add "prettyPrint", valid_580040
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

proc call*(call_580042: Call_SecuritycenterOrganizationsSourcesFindingsSetState_580026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the state of a finding.
  ## 
  let valid = call_580042.validator(path, query, header, formData, body)
  let scheme = call_580042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580042.url(scheme.get, call_580042.host, call_580042.base,
                         call_580042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580042, url, valid)

proc call*(call_580043: Call_SecuritycenterOrganizationsSourcesFindingsSetState_580026;
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
  ##       : The relative resource name of the finding. See:
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
  var path_580044 = newJObject()
  var query_580045 = newJObject()
  var body_580046 = newJObject()
  add(query_580045, "upload_protocol", newJString(uploadProtocol))
  add(query_580045, "fields", newJString(fields))
  add(query_580045, "quotaUser", newJString(quotaUser))
  add(path_580044, "name", newJString(name))
  add(query_580045, "alt", newJString(alt))
  add(query_580045, "oauth_token", newJString(oauthToken))
  add(query_580045, "callback", newJString(callback))
  add(query_580045, "access_token", newJString(accessToken))
  add(query_580045, "uploadType", newJString(uploadType))
  add(query_580045, "key", newJString(key))
  add(query_580045, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580046 = body
  add(query_580045, "prettyPrint", newJBool(prettyPrint))
  result = call_580043.call(path_580044, query_580045, nil, nil, body_580046)

var securitycenterOrganizationsSourcesFindingsSetState* = Call_SecuritycenterOrganizationsSourcesFindingsSetState_580026(
    name: "securitycenterOrganizationsSourcesFindingsSetState",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{name}:setState",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsSetState_580027,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsSetState_580028,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsList_580047 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsAssetsList_580049(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsAssetsList_580048(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists an organization's assets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the organization assets should belong to. Its format is
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580050 = path.getOrDefault("parent")
  valid_580050 = validateParameter(valid_580050, JString, required = true,
                                 default = nil)
  if valid_580050 != nil:
    section.add "parent", valid_580050
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
  var valid_580051 = query.getOrDefault("upload_protocol")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "upload_protocol", valid_580051
  var valid_580052 = query.getOrDefault("fields")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "fields", valid_580052
  var valid_580053 = query.getOrDefault("pageToken")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "pageToken", valid_580053
  var valid_580054 = query.getOrDefault("quotaUser")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "quotaUser", valid_580054
  var valid_580055 = query.getOrDefault("alt")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = newJString("json"))
  if valid_580055 != nil:
    section.add "alt", valid_580055
  var valid_580056 = query.getOrDefault("readTime")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "readTime", valid_580056
  var valid_580057 = query.getOrDefault("oauth_token")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "oauth_token", valid_580057
  var valid_580058 = query.getOrDefault("callback")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "callback", valid_580058
  var valid_580059 = query.getOrDefault("access_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "access_token", valid_580059
  var valid_580060 = query.getOrDefault("uploadType")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "uploadType", valid_580060
  var valid_580061 = query.getOrDefault("orderBy")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "orderBy", valid_580061
  var valid_580062 = query.getOrDefault("key")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "key", valid_580062
  var valid_580063 = query.getOrDefault("fieldMask")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "fieldMask", valid_580063
  var valid_580064 = query.getOrDefault("$.xgafv")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = newJString("1"))
  if valid_580064 != nil:
    section.add "$.xgafv", valid_580064
  var valid_580065 = query.getOrDefault("compareDuration")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "compareDuration", valid_580065
  var valid_580066 = query.getOrDefault("pageSize")
  valid_580066 = validateParameter(valid_580066, JInt, required = false, default = nil)
  if valid_580066 != nil:
    section.add "pageSize", valid_580066
  var valid_580067 = query.getOrDefault("prettyPrint")
  valid_580067 = validateParameter(valid_580067, JBool, required = false,
                                 default = newJBool(true))
  if valid_580067 != nil:
    section.add "prettyPrint", valid_580067
  var valid_580068 = query.getOrDefault("filter")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "filter", valid_580068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580069: Call_SecuritycenterOrganizationsAssetsList_580047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists an organization's assets.
  ## 
  let valid = call_580069.validator(path, query, header, formData, body)
  let scheme = call_580069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580069.url(scheme.get, call_580069.host, call_580069.base,
                         call_580069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580069, url, valid)

proc call*(call_580070: Call_SecuritycenterOrganizationsAssetsList_580047;
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
  ##         : Name of the organization assets should belong to. Its format is
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
  var path_580071 = newJObject()
  var query_580072 = newJObject()
  add(query_580072, "upload_protocol", newJString(uploadProtocol))
  add(query_580072, "fields", newJString(fields))
  add(query_580072, "pageToken", newJString(pageToken))
  add(query_580072, "quotaUser", newJString(quotaUser))
  add(query_580072, "alt", newJString(alt))
  add(query_580072, "readTime", newJString(readTime))
  add(query_580072, "oauth_token", newJString(oauthToken))
  add(query_580072, "callback", newJString(callback))
  add(query_580072, "access_token", newJString(accessToken))
  add(query_580072, "uploadType", newJString(uploadType))
  add(path_580071, "parent", newJString(parent))
  add(query_580072, "orderBy", newJString(orderBy))
  add(query_580072, "key", newJString(key))
  add(query_580072, "fieldMask", newJString(fieldMask))
  add(query_580072, "$.xgafv", newJString(Xgafv))
  add(query_580072, "compareDuration", newJString(compareDuration))
  add(query_580072, "pageSize", newJInt(pageSize))
  add(query_580072, "prettyPrint", newJBool(prettyPrint))
  add(query_580072, "filter", newJString(filter))
  result = call_580070.call(path_580071, query_580072, nil, nil, nil)

var securitycenterOrganizationsAssetsList* = Call_SecuritycenterOrganizationsAssetsList_580047(
    name: "securitycenterOrganizationsAssetsList", meth: HttpMethod.HttpGet,
    host: "securitycenter.googleapis.com", route: "/v1/{parent}/assets",
    validator: validate_SecuritycenterOrganizationsAssetsList_580048, base: "/",
    url: url_SecuritycenterOrganizationsAssetsList_580049, schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsGroup_580073 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsAssetsGroup_580075(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsAssetsGroup_580074(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Filters an organization's assets and  groups them by their specified
  ## properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the organization to groupBy. Its format is
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580076 = path.getOrDefault("parent")
  valid_580076 = validateParameter(valid_580076, JString, required = true,
                                 default = nil)
  if valid_580076 != nil:
    section.add "parent", valid_580076
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
  var valid_580077 = query.getOrDefault("upload_protocol")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "upload_protocol", valid_580077
  var valid_580078 = query.getOrDefault("fields")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "fields", valid_580078
  var valid_580079 = query.getOrDefault("quotaUser")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "quotaUser", valid_580079
  var valid_580080 = query.getOrDefault("alt")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = newJString("json"))
  if valid_580080 != nil:
    section.add "alt", valid_580080
  var valid_580081 = query.getOrDefault("oauth_token")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "oauth_token", valid_580081
  var valid_580082 = query.getOrDefault("callback")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "callback", valid_580082
  var valid_580083 = query.getOrDefault("access_token")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "access_token", valid_580083
  var valid_580084 = query.getOrDefault("uploadType")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "uploadType", valid_580084
  var valid_580085 = query.getOrDefault("key")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "key", valid_580085
  var valid_580086 = query.getOrDefault("$.xgafv")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = newJString("1"))
  if valid_580086 != nil:
    section.add "$.xgafv", valid_580086
  var valid_580087 = query.getOrDefault("prettyPrint")
  valid_580087 = validateParameter(valid_580087, JBool, required = false,
                                 default = newJBool(true))
  if valid_580087 != nil:
    section.add "prettyPrint", valid_580087
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

proc call*(call_580089: Call_SecuritycenterOrganizationsAssetsGroup_580073;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Filters an organization's assets and  groups them by their specified
  ## properties.
  ## 
  let valid = call_580089.validator(path, query, header, formData, body)
  let scheme = call_580089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580089.url(scheme.get, call_580089.host, call_580089.base,
                         call_580089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580089, url, valid)

proc call*(call_580090: Call_SecuritycenterOrganizationsAssetsGroup_580073;
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
  ##         : Name of the organization to groupBy. Its format is
  ## "organizations/[organization_id]".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580091 = newJObject()
  var query_580092 = newJObject()
  var body_580093 = newJObject()
  add(query_580092, "upload_protocol", newJString(uploadProtocol))
  add(query_580092, "fields", newJString(fields))
  add(query_580092, "quotaUser", newJString(quotaUser))
  add(query_580092, "alt", newJString(alt))
  add(query_580092, "oauth_token", newJString(oauthToken))
  add(query_580092, "callback", newJString(callback))
  add(query_580092, "access_token", newJString(accessToken))
  add(query_580092, "uploadType", newJString(uploadType))
  add(path_580091, "parent", newJString(parent))
  add(query_580092, "key", newJString(key))
  add(query_580092, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580093 = body
  add(query_580092, "prettyPrint", newJBool(prettyPrint))
  result = call_580090.call(path_580091, query_580092, nil, nil, body_580093)

var securitycenterOrganizationsAssetsGroup* = Call_SecuritycenterOrganizationsAssetsGroup_580073(
    name: "securitycenterOrganizationsAssetsGroup", meth: HttpMethod.HttpPost,
    host: "securitycenter.googleapis.com", route: "/v1/{parent}/assets:group",
    validator: validate_SecuritycenterOrganizationsAssetsGroup_580074, base: "/",
    url: url_SecuritycenterOrganizationsAssetsGroup_580075,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsRunDiscovery_580094 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsAssetsRunDiscovery_580096(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsAssetsRunDiscovery_580095(
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
  ##         : Name of the organization to run asset discovery for. Its format is
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580097 = path.getOrDefault("parent")
  valid_580097 = validateParameter(valid_580097, JString, required = true,
                                 default = nil)
  if valid_580097 != nil:
    section.add "parent", valid_580097
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
  var valid_580098 = query.getOrDefault("upload_protocol")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "upload_protocol", valid_580098
  var valid_580099 = query.getOrDefault("fields")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "fields", valid_580099
  var valid_580100 = query.getOrDefault("quotaUser")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "quotaUser", valid_580100
  var valid_580101 = query.getOrDefault("alt")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = newJString("json"))
  if valid_580101 != nil:
    section.add "alt", valid_580101
  var valid_580102 = query.getOrDefault("oauth_token")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "oauth_token", valid_580102
  var valid_580103 = query.getOrDefault("callback")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "callback", valid_580103
  var valid_580104 = query.getOrDefault("access_token")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "access_token", valid_580104
  var valid_580105 = query.getOrDefault("uploadType")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "uploadType", valid_580105
  var valid_580106 = query.getOrDefault("key")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "key", valid_580106
  var valid_580107 = query.getOrDefault("$.xgafv")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = newJString("1"))
  if valid_580107 != nil:
    section.add "$.xgafv", valid_580107
  var valid_580108 = query.getOrDefault("prettyPrint")
  valid_580108 = validateParameter(valid_580108, JBool, required = false,
                                 default = newJBool(true))
  if valid_580108 != nil:
    section.add "prettyPrint", valid_580108
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

proc call*(call_580110: Call_SecuritycenterOrganizationsAssetsRunDiscovery_580094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs asset discovery. The discovery is tracked with a long-running
  ## operation.
  ## 
  ## This API can only be called with limited frequency for an organization. If
  ## it is called too frequently the caller will receive a TOO_MANY_REQUESTS
  ## error.
  ## 
  let valid = call_580110.validator(path, query, header, formData, body)
  let scheme = call_580110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580110.url(scheme.get, call_580110.host, call_580110.base,
                         call_580110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580110, url, valid)

proc call*(call_580111: Call_SecuritycenterOrganizationsAssetsRunDiscovery_580094;
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
  ##         : Name of the organization to run asset discovery for. Its format is
  ## "organizations/[organization_id]".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580112 = newJObject()
  var query_580113 = newJObject()
  var body_580114 = newJObject()
  add(query_580113, "upload_protocol", newJString(uploadProtocol))
  add(query_580113, "fields", newJString(fields))
  add(query_580113, "quotaUser", newJString(quotaUser))
  add(query_580113, "alt", newJString(alt))
  add(query_580113, "oauth_token", newJString(oauthToken))
  add(query_580113, "callback", newJString(callback))
  add(query_580113, "access_token", newJString(accessToken))
  add(query_580113, "uploadType", newJString(uploadType))
  add(path_580112, "parent", newJString(parent))
  add(query_580113, "key", newJString(key))
  add(query_580113, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580114 = body
  add(query_580113, "prettyPrint", newJBool(prettyPrint))
  result = call_580111.call(path_580112, query_580113, nil, nil, body_580114)

var securitycenterOrganizationsAssetsRunDiscovery* = Call_SecuritycenterOrganizationsAssetsRunDiscovery_580094(
    name: "securitycenterOrganizationsAssetsRunDiscovery",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{parent}/assets:runDiscovery",
    validator: validate_SecuritycenterOrganizationsAssetsRunDiscovery_580095,
    base: "/", url: url_SecuritycenterOrganizationsAssetsRunDiscovery_580096,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsCreate_580141 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesFindingsCreate_580143(
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

proc validate_SecuritycenterOrganizationsSourcesFindingsCreate_580142(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a finding. The corresponding source must exist for finding creation
  ## to succeed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Resource name of the new finding's parent. Its format should be
  ## "organizations/[organization_id]/sources/[source_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580144 = path.getOrDefault("parent")
  valid_580144 = validateParameter(valid_580144, JString, required = true,
                                 default = nil)
  if valid_580144 != nil:
    section.add "parent", valid_580144
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   findingId: JString
  ##            : Unique identifier provided by the client within the parent scope.
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
  var valid_580145 = query.getOrDefault("upload_protocol")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "upload_protocol", valid_580145
  var valid_580146 = query.getOrDefault("fields")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "fields", valid_580146
  var valid_580147 = query.getOrDefault("quotaUser")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "quotaUser", valid_580147
  var valid_580148 = query.getOrDefault("findingId")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "findingId", valid_580148
  var valid_580149 = query.getOrDefault("alt")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = newJString("json"))
  if valid_580149 != nil:
    section.add "alt", valid_580149
  var valid_580150 = query.getOrDefault("oauth_token")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "oauth_token", valid_580150
  var valid_580151 = query.getOrDefault("callback")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "callback", valid_580151
  var valid_580152 = query.getOrDefault("access_token")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "access_token", valid_580152
  var valid_580153 = query.getOrDefault("uploadType")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "uploadType", valid_580153
  var valid_580154 = query.getOrDefault("key")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "key", valid_580154
  var valid_580155 = query.getOrDefault("$.xgafv")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = newJString("1"))
  if valid_580155 != nil:
    section.add "$.xgafv", valid_580155
  var valid_580156 = query.getOrDefault("prettyPrint")
  valid_580156 = validateParameter(valid_580156, JBool, required = false,
                                 default = newJBool(true))
  if valid_580156 != nil:
    section.add "prettyPrint", valid_580156
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

proc call*(call_580158: Call_SecuritycenterOrganizationsSourcesFindingsCreate_580141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a finding. The corresponding source must exist for finding creation
  ## to succeed.
  ## 
  let valid = call_580158.validator(path, query, header, formData, body)
  let scheme = call_580158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580158.url(scheme.get, call_580158.host, call_580158.base,
                         call_580158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580158, url, valid)

proc call*(call_580159: Call_SecuritycenterOrganizationsSourcesFindingsCreate_580141;
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
  ##            : Unique identifier provided by the client within the parent scope.
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
  ##         : Resource name of the new finding's parent. Its format should be
  ## "organizations/[organization_id]/sources/[source_id]".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580160 = newJObject()
  var query_580161 = newJObject()
  var body_580162 = newJObject()
  add(query_580161, "upload_protocol", newJString(uploadProtocol))
  add(query_580161, "fields", newJString(fields))
  add(query_580161, "quotaUser", newJString(quotaUser))
  add(query_580161, "findingId", newJString(findingId))
  add(query_580161, "alt", newJString(alt))
  add(query_580161, "oauth_token", newJString(oauthToken))
  add(query_580161, "callback", newJString(callback))
  add(query_580161, "access_token", newJString(accessToken))
  add(query_580161, "uploadType", newJString(uploadType))
  add(path_580160, "parent", newJString(parent))
  add(query_580161, "key", newJString(key))
  add(query_580161, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580162 = body
  add(query_580161, "prettyPrint", newJBool(prettyPrint))
  result = call_580159.call(path_580160, query_580161, nil, nil, body_580162)

var securitycenterOrganizationsSourcesFindingsCreate* = Call_SecuritycenterOrganizationsSourcesFindingsCreate_580141(
    name: "securitycenterOrganizationsSourcesFindingsCreate",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{parent}/findings",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsCreate_580142,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsCreate_580143,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsList_580115 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesFindingsList_580117(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsSourcesFindingsList_580116(
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
  ##         : Name of the source the findings belong to. Its format is
  ## "organizations/[organization_id]/sources/[source_id]". To list across all
  ## sources provide a source_id of `-`. For example:
  ## organizations/123/sources/-
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580118 = path.getOrDefault("parent")
  valid_580118 = validateParameter(valid_580118, JString, required = true,
                                 default = nil)
  if valid_580118 != nil:
    section.add "parent", valid_580118
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
  var valid_580119 = query.getOrDefault("upload_protocol")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "upload_protocol", valid_580119
  var valid_580120 = query.getOrDefault("fields")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "fields", valid_580120
  var valid_580121 = query.getOrDefault("pageToken")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "pageToken", valid_580121
  var valid_580122 = query.getOrDefault("quotaUser")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "quotaUser", valid_580122
  var valid_580123 = query.getOrDefault("alt")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = newJString("json"))
  if valid_580123 != nil:
    section.add "alt", valid_580123
  var valid_580124 = query.getOrDefault("readTime")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "readTime", valid_580124
  var valid_580125 = query.getOrDefault("oauth_token")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "oauth_token", valid_580125
  var valid_580126 = query.getOrDefault("callback")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "callback", valid_580126
  var valid_580127 = query.getOrDefault("access_token")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "access_token", valid_580127
  var valid_580128 = query.getOrDefault("uploadType")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "uploadType", valid_580128
  var valid_580129 = query.getOrDefault("orderBy")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "orderBy", valid_580129
  var valid_580130 = query.getOrDefault("key")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "key", valid_580130
  var valid_580131 = query.getOrDefault("fieldMask")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "fieldMask", valid_580131
  var valid_580132 = query.getOrDefault("$.xgafv")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = newJString("1"))
  if valid_580132 != nil:
    section.add "$.xgafv", valid_580132
  var valid_580133 = query.getOrDefault("compareDuration")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "compareDuration", valid_580133
  var valid_580134 = query.getOrDefault("pageSize")
  valid_580134 = validateParameter(valid_580134, JInt, required = false, default = nil)
  if valid_580134 != nil:
    section.add "pageSize", valid_580134
  var valid_580135 = query.getOrDefault("prettyPrint")
  valid_580135 = validateParameter(valid_580135, JBool, required = false,
                                 default = newJBool(true))
  if valid_580135 != nil:
    section.add "prettyPrint", valid_580135
  var valid_580136 = query.getOrDefault("filter")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "filter", valid_580136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580137: Call_SecuritycenterOrganizationsSourcesFindingsList_580115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists an organization or source's findings.
  ## 
  ## To list across all sources provide a `-` as the source id.
  ## Example: /v1/organizations/123/sources/-/findings
  ## 
  let valid = call_580137.validator(path, query, header, formData, body)
  let scheme = call_580137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580137.url(scheme.get, call_580137.host, call_580137.base,
                         call_580137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580137, url, valid)

proc call*(call_580138: Call_SecuritycenterOrganizationsSourcesFindingsList_580115;
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
  ##         : Name of the source the findings belong to. Its format is
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
  var path_580139 = newJObject()
  var query_580140 = newJObject()
  add(query_580140, "upload_protocol", newJString(uploadProtocol))
  add(query_580140, "fields", newJString(fields))
  add(query_580140, "pageToken", newJString(pageToken))
  add(query_580140, "quotaUser", newJString(quotaUser))
  add(query_580140, "alt", newJString(alt))
  add(query_580140, "readTime", newJString(readTime))
  add(query_580140, "oauth_token", newJString(oauthToken))
  add(query_580140, "callback", newJString(callback))
  add(query_580140, "access_token", newJString(accessToken))
  add(query_580140, "uploadType", newJString(uploadType))
  add(path_580139, "parent", newJString(parent))
  add(query_580140, "orderBy", newJString(orderBy))
  add(query_580140, "key", newJString(key))
  add(query_580140, "fieldMask", newJString(fieldMask))
  add(query_580140, "$.xgafv", newJString(Xgafv))
  add(query_580140, "compareDuration", newJString(compareDuration))
  add(query_580140, "pageSize", newJInt(pageSize))
  add(query_580140, "prettyPrint", newJBool(prettyPrint))
  add(query_580140, "filter", newJString(filter))
  result = call_580138.call(path_580139, query_580140, nil, nil, nil)

var securitycenterOrganizationsSourcesFindingsList* = Call_SecuritycenterOrganizationsSourcesFindingsList_580115(
    name: "securitycenterOrganizationsSourcesFindingsList",
    meth: HttpMethod.HttpGet, host: "securitycenter.googleapis.com",
    route: "/v1/{parent}/findings",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsList_580116,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsList_580117,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsGroup_580163 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesFindingsGroup_580165(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsSourcesFindingsGroup_580164(
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
  ##         : Name of the source to groupBy. Its format is
  ## "organizations/[organization_id]/sources/[source_id]". To groupBy across
  ## all sources provide a source_id of `-`. For example:
  ## organizations/123/sources/-
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580166 = path.getOrDefault("parent")
  valid_580166 = validateParameter(valid_580166, JString, required = true,
                                 default = nil)
  if valid_580166 != nil:
    section.add "parent", valid_580166
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
  var valid_580167 = query.getOrDefault("upload_protocol")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "upload_protocol", valid_580167
  var valid_580168 = query.getOrDefault("fields")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "fields", valid_580168
  var valid_580169 = query.getOrDefault("quotaUser")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "quotaUser", valid_580169
  var valid_580170 = query.getOrDefault("alt")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("json"))
  if valid_580170 != nil:
    section.add "alt", valid_580170
  var valid_580171 = query.getOrDefault("oauth_token")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "oauth_token", valid_580171
  var valid_580172 = query.getOrDefault("callback")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "callback", valid_580172
  var valid_580173 = query.getOrDefault("access_token")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "access_token", valid_580173
  var valid_580174 = query.getOrDefault("uploadType")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "uploadType", valid_580174
  var valid_580175 = query.getOrDefault("key")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "key", valid_580175
  var valid_580176 = query.getOrDefault("$.xgafv")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = newJString("1"))
  if valid_580176 != nil:
    section.add "$.xgafv", valid_580176
  var valid_580177 = query.getOrDefault("prettyPrint")
  valid_580177 = validateParameter(valid_580177, JBool, required = false,
                                 default = newJBool(true))
  if valid_580177 != nil:
    section.add "prettyPrint", valid_580177
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

proc call*(call_580179: Call_SecuritycenterOrganizationsSourcesFindingsGroup_580163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Filters an organization or source's findings and  groups them by their
  ## specified properties.
  ## 
  ## To group across all sources provide a `-` as the source id.
  ## Example: /v1/organizations/123/sources/-/findings
  ## 
  let valid = call_580179.validator(path, query, header, formData, body)
  let scheme = call_580179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580179.url(scheme.get, call_580179.host, call_580179.base,
                         call_580179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580179, url, valid)

proc call*(call_580180: Call_SecuritycenterOrganizationsSourcesFindingsGroup_580163;
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
  ##         : Name of the source to groupBy. Its format is
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
  var path_580181 = newJObject()
  var query_580182 = newJObject()
  var body_580183 = newJObject()
  add(query_580182, "upload_protocol", newJString(uploadProtocol))
  add(query_580182, "fields", newJString(fields))
  add(query_580182, "quotaUser", newJString(quotaUser))
  add(query_580182, "alt", newJString(alt))
  add(query_580182, "oauth_token", newJString(oauthToken))
  add(query_580182, "callback", newJString(callback))
  add(query_580182, "access_token", newJString(accessToken))
  add(query_580182, "uploadType", newJString(uploadType))
  add(path_580181, "parent", newJString(parent))
  add(query_580182, "key", newJString(key))
  add(query_580182, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580183 = body
  add(query_580182, "prettyPrint", newJBool(prettyPrint))
  result = call_580180.call(path_580181, query_580182, nil, nil, body_580183)

var securitycenterOrganizationsSourcesFindingsGroup* = Call_SecuritycenterOrganizationsSourcesFindingsGroup_580163(
    name: "securitycenterOrganizationsSourcesFindingsGroup",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{parent}/findings:group",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsGroup_580164,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsGroup_580165,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesCreate_580205 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesCreate_580207(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsSourcesCreate_580206(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Resource name of the new source's parent. Its format should be
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580208 = path.getOrDefault("parent")
  valid_580208 = validateParameter(valid_580208, JString, required = true,
                                 default = nil)
  if valid_580208 != nil:
    section.add "parent", valid_580208
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
  var valid_580209 = query.getOrDefault("upload_protocol")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "upload_protocol", valid_580209
  var valid_580210 = query.getOrDefault("fields")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "fields", valid_580210
  var valid_580211 = query.getOrDefault("quotaUser")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "quotaUser", valid_580211
  var valid_580212 = query.getOrDefault("alt")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = newJString("json"))
  if valid_580212 != nil:
    section.add "alt", valid_580212
  var valid_580213 = query.getOrDefault("oauth_token")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "oauth_token", valid_580213
  var valid_580214 = query.getOrDefault("callback")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "callback", valid_580214
  var valid_580215 = query.getOrDefault("access_token")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "access_token", valid_580215
  var valid_580216 = query.getOrDefault("uploadType")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "uploadType", valid_580216
  var valid_580217 = query.getOrDefault("key")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "key", valid_580217
  var valid_580218 = query.getOrDefault("$.xgafv")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = newJString("1"))
  if valid_580218 != nil:
    section.add "$.xgafv", valid_580218
  var valid_580219 = query.getOrDefault("prettyPrint")
  valid_580219 = validateParameter(valid_580219, JBool, required = false,
                                 default = newJBool(true))
  if valid_580219 != nil:
    section.add "prettyPrint", valid_580219
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

proc call*(call_580221: Call_SecuritycenterOrganizationsSourcesCreate_580205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a source.
  ## 
  let valid = call_580221.validator(path, query, header, formData, body)
  let scheme = call_580221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580221.url(scheme.get, call_580221.host, call_580221.base,
                         call_580221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580221, url, valid)

proc call*(call_580222: Call_SecuritycenterOrganizationsSourcesCreate_580205;
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
  ##         : Resource name of the new source's parent. Its format should be
  ## "organizations/[organization_id]".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580223 = newJObject()
  var query_580224 = newJObject()
  var body_580225 = newJObject()
  add(query_580224, "upload_protocol", newJString(uploadProtocol))
  add(query_580224, "fields", newJString(fields))
  add(query_580224, "quotaUser", newJString(quotaUser))
  add(query_580224, "alt", newJString(alt))
  add(query_580224, "oauth_token", newJString(oauthToken))
  add(query_580224, "callback", newJString(callback))
  add(query_580224, "access_token", newJString(accessToken))
  add(query_580224, "uploadType", newJString(uploadType))
  add(path_580223, "parent", newJString(parent))
  add(query_580224, "key", newJString(key))
  add(query_580224, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580225 = body
  add(query_580224, "prettyPrint", newJBool(prettyPrint))
  result = call_580222.call(path_580223, query_580224, nil, nil, body_580225)

var securitycenterOrganizationsSourcesCreate* = Call_SecuritycenterOrganizationsSourcesCreate_580205(
    name: "securitycenterOrganizationsSourcesCreate", meth: HttpMethod.HttpPost,
    host: "securitycenter.googleapis.com", route: "/v1/{parent}/sources",
    validator: validate_SecuritycenterOrganizationsSourcesCreate_580206,
    base: "/", url: url_SecuritycenterOrganizationsSourcesCreate_580207,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesList_580184 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesList_580186(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsSourcesList_580185(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all sources belonging to an organization.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Resource name of the parent of sources to list. Its format should be
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580187 = path.getOrDefault("parent")
  valid_580187 = validateParameter(valid_580187, JString, required = true,
                                 default = nil)
  if valid_580187 != nil:
    section.add "parent", valid_580187
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
  var valid_580188 = query.getOrDefault("upload_protocol")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "upload_protocol", valid_580188
  var valid_580189 = query.getOrDefault("fields")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "fields", valid_580189
  var valid_580190 = query.getOrDefault("pageToken")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "pageToken", valid_580190
  var valid_580191 = query.getOrDefault("quotaUser")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "quotaUser", valid_580191
  var valid_580192 = query.getOrDefault("alt")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = newJString("json"))
  if valid_580192 != nil:
    section.add "alt", valid_580192
  var valid_580193 = query.getOrDefault("oauth_token")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "oauth_token", valid_580193
  var valid_580194 = query.getOrDefault("callback")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "callback", valid_580194
  var valid_580195 = query.getOrDefault("access_token")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "access_token", valid_580195
  var valid_580196 = query.getOrDefault("uploadType")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "uploadType", valid_580196
  var valid_580197 = query.getOrDefault("key")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "key", valid_580197
  var valid_580198 = query.getOrDefault("$.xgafv")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = newJString("1"))
  if valid_580198 != nil:
    section.add "$.xgafv", valid_580198
  var valid_580199 = query.getOrDefault("pageSize")
  valid_580199 = validateParameter(valid_580199, JInt, required = false, default = nil)
  if valid_580199 != nil:
    section.add "pageSize", valid_580199
  var valid_580200 = query.getOrDefault("prettyPrint")
  valid_580200 = validateParameter(valid_580200, JBool, required = false,
                                 default = newJBool(true))
  if valid_580200 != nil:
    section.add "prettyPrint", valid_580200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580201: Call_SecuritycenterOrganizationsSourcesList_580184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all sources belonging to an organization.
  ## 
  let valid = call_580201.validator(path, query, header, formData, body)
  let scheme = call_580201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580201.url(scheme.get, call_580201.host, call_580201.base,
                         call_580201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580201, url, valid)

proc call*(call_580202: Call_SecuritycenterOrganizationsSourcesList_580184;
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
  ##         : Resource name of the parent of sources to list. Its format should be
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
  var path_580203 = newJObject()
  var query_580204 = newJObject()
  add(query_580204, "upload_protocol", newJString(uploadProtocol))
  add(query_580204, "fields", newJString(fields))
  add(query_580204, "pageToken", newJString(pageToken))
  add(query_580204, "quotaUser", newJString(quotaUser))
  add(query_580204, "alt", newJString(alt))
  add(query_580204, "oauth_token", newJString(oauthToken))
  add(query_580204, "callback", newJString(callback))
  add(query_580204, "access_token", newJString(accessToken))
  add(query_580204, "uploadType", newJString(uploadType))
  add(path_580203, "parent", newJString(parent))
  add(query_580204, "key", newJString(key))
  add(query_580204, "$.xgafv", newJString(Xgafv))
  add(query_580204, "pageSize", newJInt(pageSize))
  add(query_580204, "prettyPrint", newJBool(prettyPrint))
  result = call_580202.call(path_580203, query_580204, nil, nil, nil)

var securitycenterOrganizationsSourcesList* = Call_SecuritycenterOrganizationsSourcesList_580184(
    name: "securitycenterOrganizationsSourcesList", meth: HttpMethod.HttpGet,
    host: "securitycenter.googleapis.com", route: "/v1/{parent}/sources",
    validator: validate_SecuritycenterOrganizationsSourcesList_580185, base: "/",
    url: url_SecuritycenterOrganizationsSourcesList_580186,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesGetIamPolicy_580226 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesGetIamPolicy_580228(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsSourcesGetIamPolicy_580227(
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
  var valid_580229 = path.getOrDefault("resource")
  valid_580229 = validateParameter(valid_580229, JString, required = true,
                                 default = nil)
  if valid_580229 != nil:
    section.add "resource", valid_580229
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
  var valid_580230 = query.getOrDefault("upload_protocol")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "upload_protocol", valid_580230
  var valid_580231 = query.getOrDefault("fields")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "fields", valid_580231
  var valid_580232 = query.getOrDefault("quotaUser")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "quotaUser", valid_580232
  var valid_580233 = query.getOrDefault("alt")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = newJString("json"))
  if valid_580233 != nil:
    section.add "alt", valid_580233
  var valid_580234 = query.getOrDefault("oauth_token")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "oauth_token", valid_580234
  var valid_580235 = query.getOrDefault("callback")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "callback", valid_580235
  var valid_580236 = query.getOrDefault("access_token")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "access_token", valid_580236
  var valid_580237 = query.getOrDefault("uploadType")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "uploadType", valid_580237
  var valid_580238 = query.getOrDefault("key")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "key", valid_580238
  var valid_580239 = query.getOrDefault("$.xgafv")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = newJString("1"))
  if valid_580239 != nil:
    section.add "$.xgafv", valid_580239
  var valid_580240 = query.getOrDefault("prettyPrint")
  valid_580240 = validateParameter(valid_580240, JBool, required = false,
                                 default = newJBool(true))
  if valid_580240 != nil:
    section.add "prettyPrint", valid_580240
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

proc call*(call_580242: Call_SecuritycenterOrganizationsSourcesGetIamPolicy_580226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy on the specified Source.
  ## 
  let valid = call_580242.validator(path, query, header, formData, body)
  let scheme = call_580242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580242.url(scheme.get, call_580242.host, call_580242.base,
                         call_580242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580242, url, valid)

proc call*(call_580243: Call_SecuritycenterOrganizationsSourcesGetIamPolicy_580226;
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
  var path_580244 = newJObject()
  var query_580245 = newJObject()
  var body_580246 = newJObject()
  add(query_580245, "upload_protocol", newJString(uploadProtocol))
  add(query_580245, "fields", newJString(fields))
  add(query_580245, "quotaUser", newJString(quotaUser))
  add(query_580245, "alt", newJString(alt))
  add(query_580245, "oauth_token", newJString(oauthToken))
  add(query_580245, "callback", newJString(callback))
  add(query_580245, "access_token", newJString(accessToken))
  add(query_580245, "uploadType", newJString(uploadType))
  add(query_580245, "key", newJString(key))
  add(query_580245, "$.xgafv", newJString(Xgafv))
  add(path_580244, "resource", newJString(resource))
  if body != nil:
    body_580246 = body
  add(query_580245, "prettyPrint", newJBool(prettyPrint))
  result = call_580243.call(path_580244, query_580245, nil, nil, body_580246)

var securitycenterOrganizationsSourcesGetIamPolicy* = Call_SecuritycenterOrganizationsSourcesGetIamPolicy_580226(
    name: "securitycenterOrganizationsSourcesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_SecuritycenterOrganizationsSourcesGetIamPolicy_580227,
    base: "/", url: url_SecuritycenterOrganizationsSourcesGetIamPolicy_580228,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesSetIamPolicy_580247 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesSetIamPolicy_580249(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsSourcesSetIamPolicy_580248(
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
  var valid_580250 = path.getOrDefault("resource")
  valid_580250 = validateParameter(valid_580250, JString, required = true,
                                 default = nil)
  if valid_580250 != nil:
    section.add "resource", valid_580250
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
  var valid_580251 = query.getOrDefault("upload_protocol")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "upload_protocol", valid_580251
  var valid_580252 = query.getOrDefault("fields")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "fields", valid_580252
  var valid_580253 = query.getOrDefault("quotaUser")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "quotaUser", valid_580253
  var valid_580254 = query.getOrDefault("alt")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = newJString("json"))
  if valid_580254 != nil:
    section.add "alt", valid_580254
  var valid_580255 = query.getOrDefault("oauth_token")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "oauth_token", valid_580255
  var valid_580256 = query.getOrDefault("callback")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "callback", valid_580256
  var valid_580257 = query.getOrDefault("access_token")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "access_token", valid_580257
  var valid_580258 = query.getOrDefault("uploadType")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "uploadType", valid_580258
  var valid_580259 = query.getOrDefault("key")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "key", valid_580259
  var valid_580260 = query.getOrDefault("$.xgafv")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = newJString("1"))
  if valid_580260 != nil:
    section.add "$.xgafv", valid_580260
  var valid_580261 = query.getOrDefault("prettyPrint")
  valid_580261 = validateParameter(valid_580261, JBool, required = false,
                                 default = newJBool(true))
  if valid_580261 != nil:
    section.add "prettyPrint", valid_580261
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

proc call*(call_580263: Call_SecuritycenterOrganizationsSourcesSetIamPolicy_580247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified Source.
  ## 
  let valid = call_580263.validator(path, query, header, formData, body)
  let scheme = call_580263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580263.url(scheme.get, call_580263.host, call_580263.base,
                         call_580263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580263, url, valid)

proc call*(call_580264: Call_SecuritycenterOrganizationsSourcesSetIamPolicy_580247;
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
  var path_580265 = newJObject()
  var query_580266 = newJObject()
  var body_580267 = newJObject()
  add(query_580266, "upload_protocol", newJString(uploadProtocol))
  add(query_580266, "fields", newJString(fields))
  add(query_580266, "quotaUser", newJString(quotaUser))
  add(query_580266, "alt", newJString(alt))
  add(query_580266, "oauth_token", newJString(oauthToken))
  add(query_580266, "callback", newJString(callback))
  add(query_580266, "access_token", newJString(accessToken))
  add(query_580266, "uploadType", newJString(uploadType))
  add(query_580266, "key", newJString(key))
  add(query_580266, "$.xgafv", newJString(Xgafv))
  add(path_580265, "resource", newJString(resource))
  if body != nil:
    body_580267 = body
  add(query_580266, "prettyPrint", newJBool(prettyPrint))
  result = call_580264.call(path_580265, query_580266, nil, nil, body_580267)

var securitycenterOrganizationsSourcesSetIamPolicy* = Call_SecuritycenterOrganizationsSourcesSetIamPolicy_580247(
    name: "securitycenterOrganizationsSourcesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_SecuritycenterOrganizationsSourcesSetIamPolicy_580248,
    base: "/", url: url_SecuritycenterOrganizationsSourcesSetIamPolicy_580249,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesTestIamPermissions_580268 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesTestIamPermissions_580270(
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

proc validate_SecuritycenterOrganizationsSourcesTestIamPermissions_580269(
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
  var valid_580271 = path.getOrDefault("resource")
  valid_580271 = validateParameter(valid_580271, JString, required = true,
                                 default = nil)
  if valid_580271 != nil:
    section.add "resource", valid_580271
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
  var valid_580272 = query.getOrDefault("upload_protocol")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "upload_protocol", valid_580272
  var valid_580273 = query.getOrDefault("fields")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "fields", valid_580273
  var valid_580274 = query.getOrDefault("quotaUser")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "quotaUser", valid_580274
  var valid_580275 = query.getOrDefault("alt")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = newJString("json"))
  if valid_580275 != nil:
    section.add "alt", valid_580275
  var valid_580276 = query.getOrDefault("oauth_token")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "oauth_token", valid_580276
  var valid_580277 = query.getOrDefault("callback")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "callback", valid_580277
  var valid_580278 = query.getOrDefault("access_token")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "access_token", valid_580278
  var valid_580279 = query.getOrDefault("uploadType")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "uploadType", valid_580279
  var valid_580280 = query.getOrDefault("key")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "key", valid_580280
  var valid_580281 = query.getOrDefault("$.xgafv")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = newJString("1"))
  if valid_580281 != nil:
    section.add "$.xgafv", valid_580281
  var valid_580282 = query.getOrDefault("prettyPrint")
  valid_580282 = validateParameter(valid_580282, JBool, required = false,
                                 default = newJBool(true))
  if valid_580282 != nil:
    section.add "prettyPrint", valid_580282
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

proc call*(call_580284: Call_SecuritycenterOrganizationsSourcesTestIamPermissions_580268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the permissions that a caller has on the specified source.
  ## 
  let valid = call_580284.validator(path, query, header, formData, body)
  let scheme = call_580284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580284.url(scheme.get, call_580284.host, call_580284.base,
                         call_580284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580284, url, valid)

proc call*(call_580285: Call_SecuritycenterOrganizationsSourcesTestIamPermissions_580268;
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
  var path_580286 = newJObject()
  var query_580287 = newJObject()
  var body_580288 = newJObject()
  add(query_580287, "upload_protocol", newJString(uploadProtocol))
  add(query_580287, "fields", newJString(fields))
  add(query_580287, "quotaUser", newJString(quotaUser))
  add(query_580287, "alt", newJString(alt))
  add(query_580287, "oauth_token", newJString(oauthToken))
  add(query_580287, "callback", newJString(callback))
  add(query_580287, "access_token", newJString(accessToken))
  add(query_580287, "uploadType", newJString(uploadType))
  add(query_580287, "key", newJString(key))
  add(query_580287, "$.xgafv", newJString(Xgafv))
  add(path_580286, "resource", newJString(resource))
  if body != nil:
    body_580288 = body
  add(query_580287, "prettyPrint", newJBool(prettyPrint))
  result = call_580285.call(path_580286, query_580287, nil, nil, body_580288)

var securitycenterOrganizationsSourcesTestIamPermissions* = Call_SecuritycenterOrganizationsSourcesTestIamPermissions_580268(
    name: "securitycenterOrganizationsSourcesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_SecuritycenterOrganizationsSourcesTestIamPermissions_580269,
    base: "/", url: url_SecuritycenterOrganizationsSourcesTestIamPermissions_580270,
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
