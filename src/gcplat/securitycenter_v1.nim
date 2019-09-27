
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SecuritycenterOrganizationsOperationsGet_593677 = ref object of OpenApiRestCall_593408
proc url_SecuritycenterOrganizationsOperationsGet_593679(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsOperationsGet_593678(path: JsonNode;
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
  var valid_593805 = path.getOrDefault("name")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "name", valid_593805
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
  var valid_593806 = query.getOrDefault("upload_protocol")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "upload_protocol", valid_593806
  var valid_593807 = query.getOrDefault("fields")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "fields", valid_593807
  var valid_593808 = query.getOrDefault("quotaUser")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "quotaUser", valid_593808
  var valid_593822 = query.getOrDefault("alt")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = newJString("json"))
  if valid_593822 != nil:
    section.add "alt", valid_593822
  var valid_593823 = query.getOrDefault("oauth_token")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "oauth_token", valid_593823
  var valid_593824 = query.getOrDefault("callback")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "callback", valid_593824
  var valid_593825 = query.getOrDefault("access_token")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "access_token", valid_593825
  var valid_593826 = query.getOrDefault("uploadType")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "uploadType", valid_593826
  var valid_593827 = query.getOrDefault("key")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "key", valid_593827
  var valid_593828 = query.getOrDefault("$.xgafv")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = newJString("1"))
  if valid_593828 != nil:
    section.add "$.xgafv", valid_593828
  var valid_593829 = query.getOrDefault("prettyPrint")
  valid_593829 = validateParameter(valid_593829, JBool, required = false,
                                 default = newJBool(true))
  if valid_593829 != nil:
    section.add "prettyPrint", valid_593829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593852: Call_SecuritycenterOrganizationsOperationsGet_593677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_593852.validator(path, query, header, formData, body)
  let scheme = call_593852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593852.url(scheme.get, call_593852.host, call_593852.base,
                         call_593852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593852, url, valid)

proc call*(call_593923: Call_SecuritycenterOrganizationsOperationsGet_593677;
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
  var path_593924 = newJObject()
  var query_593926 = newJObject()
  add(query_593926, "upload_protocol", newJString(uploadProtocol))
  add(query_593926, "fields", newJString(fields))
  add(query_593926, "quotaUser", newJString(quotaUser))
  add(path_593924, "name", newJString(name))
  add(query_593926, "alt", newJString(alt))
  add(query_593926, "oauth_token", newJString(oauthToken))
  add(query_593926, "callback", newJString(callback))
  add(query_593926, "access_token", newJString(accessToken))
  add(query_593926, "uploadType", newJString(uploadType))
  add(query_593926, "key", newJString(key))
  add(query_593926, "$.xgafv", newJString(Xgafv))
  add(query_593926, "prettyPrint", newJBool(prettyPrint))
  result = call_593923.call(path_593924, query_593926, nil, nil, nil)

var securitycenterOrganizationsOperationsGet* = Call_SecuritycenterOrganizationsOperationsGet_593677(
    name: "securitycenterOrganizationsOperationsGet", meth: HttpMethod.HttpGet,
    host: "securitycenter.googleapis.com", route: "/v1/{name}",
    validator: validate_SecuritycenterOrganizationsOperationsGet_593678,
    base: "/", url: url_SecuritycenterOrganizationsOperationsGet_593679,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_593984 = ref object of OpenApiRestCall_593408
proc url_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_593986(
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

proc validate_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_593985(
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
  var valid_593987 = path.getOrDefault("name")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "name", valid_593987
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
  var valid_593988 = query.getOrDefault("upload_protocol")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "upload_protocol", valid_593988
  var valid_593989 = query.getOrDefault("fields")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "fields", valid_593989
  var valid_593990 = query.getOrDefault("quotaUser")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "quotaUser", valid_593990
  var valid_593991 = query.getOrDefault("alt")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("json"))
  if valid_593991 != nil:
    section.add "alt", valid_593991
  var valid_593992 = query.getOrDefault("oauth_token")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "oauth_token", valid_593992
  var valid_593993 = query.getOrDefault("callback")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "callback", valid_593993
  var valid_593994 = query.getOrDefault("access_token")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "access_token", valid_593994
  var valid_593995 = query.getOrDefault("uploadType")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "uploadType", valid_593995
  var valid_593996 = query.getOrDefault("key")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "key", valid_593996
  var valid_593997 = query.getOrDefault("$.xgafv")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = newJString("1"))
  if valid_593997 != nil:
    section.add "$.xgafv", valid_593997
  var valid_593998 = query.getOrDefault("prettyPrint")
  valid_593998 = validateParameter(valid_593998, JBool, required = false,
                                 default = newJBool(true))
  if valid_593998 != nil:
    section.add "prettyPrint", valid_593998
  var valid_593999 = query.getOrDefault("startTime")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "startTime", valid_593999
  var valid_594000 = query.getOrDefault("updateMask")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "updateMask", valid_594000
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

proc call*(call_594002: Call_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_593984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates security marks.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_593984;
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
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  var body_594006 = newJObject()
  add(query_594005, "upload_protocol", newJString(uploadProtocol))
  add(query_594005, "fields", newJString(fields))
  add(query_594005, "quotaUser", newJString(quotaUser))
  add(path_594004, "name", newJString(name))
  add(query_594005, "alt", newJString(alt))
  add(query_594005, "oauth_token", newJString(oauthToken))
  add(query_594005, "callback", newJString(callback))
  add(query_594005, "access_token", newJString(accessToken))
  add(query_594005, "uploadType", newJString(uploadType))
  add(query_594005, "key", newJString(key))
  add(query_594005, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594006 = body
  add(query_594005, "prettyPrint", newJBool(prettyPrint))
  add(query_594005, "startTime", newJString(startTime))
  add(query_594005, "updateMask", newJString(updateMask))
  result = call_594003.call(path_594004, query_594005, nil, nil, body_594006)

var securitycenterOrganizationsSourcesFindingsUpdateSecurityMarks* = Call_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_593984(
    name: "securitycenterOrganizationsSourcesFindingsUpdateSecurityMarks",
    meth: HttpMethod.HttpPatch, host: "securitycenter.googleapis.com",
    route: "/v1/{name}", validator: validate_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_593985,
    base: "/",
    url: url_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_593986,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsOperationsDelete_593965 = ref object of OpenApiRestCall_593408
proc url_SecuritycenterOrganizationsOperationsDelete_593967(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsOperationsDelete_593966(path: JsonNode;
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
  var valid_593968 = path.getOrDefault("name")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "name", valid_593968
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
  var valid_593969 = query.getOrDefault("upload_protocol")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "upload_protocol", valid_593969
  var valid_593970 = query.getOrDefault("fields")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "fields", valid_593970
  var valid_593971 = query.getOrDefault("quotaUser")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "quotaUser", valid_593971
  var valid_593972 = query.getOrDefault("alt")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = newJString("json"))
  if valid_593972 != nil:
    section.add "alt", valid_593972
  var valid_593973 = query.getOrDefault("oauth_token")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "oauth_token", valid_593973
  var valid_593974 = query.getOrDefault("callback")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "callback", valid_593974
  var valid_593975 = query.getOrDefault("access_token")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "access_token", valid_593975
  var valid_593976 = query.getOrDefault("uploadType")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "uploadType", valid_593976
  var valid_593977 = query.getOrDefault("key")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "key", valid_593977
  var valid_593978 = query.getOrDefault("$.xgafv")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = newJString("1"))
  if valid_593978 != nil:
    section.add "$.xgafv", valid_593978
  var valid_593979 = query.getOrDefault("prettyPrint")
  valid_593979 = validateParameter(valid_593979, JBool, required = false,
                                 default = newJBool(true))
  if valid_593979 != nil:
    section.add "prettyPrint", valid_593979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593980: Call_SecuritycenterOrganizationsOperationsDelete_593965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_SecuritycenterOrganizationsOperationsDelete_593965;
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
  var path_593982 = newJObject()
  var query_593983 = newJObject()
  add(query_593983, "upload_protocol", newJString(uploadProtocol))
  add(query_593983, "fields", newJString(fields))
  add(query_593983, "quotaUser", newJString(quotaUser))
  add(path_593982, "name", newJString(name))
  add(query_593983, "alt", newJString(alt))
  add(query_593983, "oauth_token", newJString(oauthToken))
  add(query_593983, "callback", newJString(callback))
  add(query_593983, "access_token", newJString(accessToken))
  add(query_593983, "uploadType", newJString(uploadType))
  add(query_593983, "key", newJString(key))
  add(query_593983, "$.xgafv", newJString(Xgafv))
  add(query_593983, "prettyPrint", newJBool(prettyPrint))
  result = call_593981.call(path_593982, query_593983, nil, nil, nil)

var securitycenterOrganizationsOperationsDelete* = Call_SecuritycenterOrganizationsOperationsDelete_593965(
    name: "securitycenterOrganizationsOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "securitycenter.googleapis.com",
    route: "/v1/{name}",
    validator: validate_SecuritycenterOrganizationsOperationsDelete_593966,
    base: "/", url: url_SecuritycenterOrganizationsOperationsDelete_593967,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsOperationsCancel_594007 = ref object of OpenApiRestCall_593408
proc url_SecuritycenterOrganizationsOperationsCancel_594009(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SecuritycenterOrganizationsOperationsCancel_594008(path: JsonNode;
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
  var valid_594010 = path.getOrDefault("name")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "name", valid_594010
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
  var valid_594011 = query.getOrDefault("upload_protocol")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "upload_protocol", valid_594011
  var valid_594012 = query.getOrDefault("fields")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "fields", valid_594012
  var valid_594013 = query.getOrDefault("quotaUser")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "quotaUser", valid_594013
  var valid_594014 = query.getOrDefault("alt")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = newJString("json"))
  if valid_594014 != nil:
    section.add "alt", valid_594014
  var valid_594015 = query.getOrDefault("oauth_token")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "oauth_token", valid_594015
  var valid_594016 = query.getOrDefault("callback")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "callback", valid_594016
  var valid_594017 = query.getOrDefault("access_token")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "access_token", valid_594017
  var valid_594018 = query.getOrDefault("uploadType")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "uploadType", valid_594018
  var valid_594019 = query.getOrDefault("key")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "key", valid_594019
  var valid_594020 = query.getOrDefault("$.xgafv")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = newJString("1"))
  if valid_594020 != nil:
    section.add "$.xgafv", valid_594020
  var valid_594021 = query.getOrDefault("prettyPrint")
  valid_594021 = validateParameter(valid_594021, JBool, required = false,
                                 default = newJBool(true))
  if valid_594021 != nil:
    section.add "prettyPrint", valid_594021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594022: Call_SecuritycenterOrganizationsOperationsCancel_594007;
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
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_SecuritycenterOrganizationsOperationsCancel_594007;
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
  var path_594024 = newJObject()
  var query_594025 = newJObject()
  add(query_594025, "upload_protocol", newJString(uploadProtocol))
  add(query_594025, "fields", newJString(fields))
  add(query_594025, "quotaUser", newJString(quotaUser))
  add(path_594024, "name", newJString(name))
  add(query_594025, "alt", newJString(alt))
  add(query_594025, "oauth_token", newJString(oauthToken))
  add(query_594025, "callback", newJString(callback))
  add(query_594025, "access_token", newJString(accessToken))
  add(query_594025, "uploadType", newJString(uploadType))
  add(query_594025, "key", newJString(key))
  add(query_594025, "$.xgafv", newJString(Xgafv))
  add(query_594025, "prettyPrint", newJBool(prettyPrint))
  result = call_594023.call(path_594024, query_594025, nil, nil, nil)

var securitycenterOrganizationsOperationsCancel* = Call_SecuritycenterOrganizationsOperationsCancel_594007(
    name: "securitycenterOrganizationsOperationsCancel",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{name}:cancel",
    validator: validate_SecuritycenterOrganizationsOperationsCancel_594008,
    base: "/", url: url_SecuritycenterOrganizationsOperationsCancel_594009,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsSetState_594026 = ref object of OpenApiRestCall_593408
proc url_SecuritycenterOrganizationsSourcesFindingsSetState_594028(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SecuritycenterOrganizationsSourcesFindingsSetState_594027(
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
  var valid_594029 = path.getOrDefault("name")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "name", valid_594029
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
  var valid_594030 = query.getOrDefault("upload_protocol")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "upload_protocol", valid_594030
  var valid_594031 = query.getOrDefault("fields")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "fields", valid_594031
  var valid_594032 = query.getOrDefault("quotaUser")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "quotaUser", valid_594032
  var valid_594033 = query.getOrDefault("alt")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = newJString("json"))
  if valid_594033 != nil:
    section.add "alt", valid_594033
  var valid_594034 = query.getOrDefault("oauth_token")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "oauth_token", valid_594034
  var valid_594035 = query.getOrDefault("callback")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "callback", valid_594035
  var valid_594036 = query.getOrDefault("access_token")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "access_token", valid_594036
  var valid_594037 = query.getOrDefault("uploadType")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "uploadType", valid_594037
  var valid_594038 = query.getOrDefault("key")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "key", valid_594038
  var valid_594039 = query.getOrDefault("$.xgafv")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = newJString("1"))
  if valid_594039 != nil:
    section.add "$.xgafv", valid_594039
  var valid_594040 = query.getOrDefault("prettyPrint")
  valid_594040 = validateParameter(valid_594040, JBool, required = false,
                                 default = newJBool(true))
  if valid_594040 != nil:
    section.add "prettyPrint", valid_594040
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

proc call*(call_594042: Call_SecuritycenterOrganizationsSourcesFindingsSetState_594026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the state of a finding.
  ## 
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_SecuritycenterOrganizationsSourcesFindingsSetState_594026;
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
  var path_594044 = newJObject()
  var query_594045 = newJObject()
  var body_594046 = newJObject()
  add(query_594045, "upload_protocol", newJString(uploadProtocol))
  add(query_594045, "fields", newJString(fields))
  add(query_594045, "quotaUser", newJString(quotaUser))
  add(path_594044, "name", newJString(name))
  add(query_594045, "alt", newJString(alt))
  add(query_594045, "oauth_token", newJString(oauthToken))
  add(query_594045, "callback", newJString(callback))
  add(query_594045, "access_token", newJString(accessToken))
  add(query_594045, "uploadType", newJString(uploadType))
  add(query_594045, "key", newJString(key))
  add(query_594045, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594046 = body
  add(query_594045, "prettyPrint", newJBool(prettyPrint))
  result = call_594043.call(path_594044, query_594045, nil, nil, body_594046)

var securitycenterOrganizationsSourcesFindingsSetState* = Call_SecuritycenterOrganizationsSourcesFindingsSetState_594026(
    name: "securitycenterOrganizationsSourcesFindingsSetState",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{name}:setState",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsSetState_594027,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsSetState_594028,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsList_594047 = ref object of OpenApiRestCall_593408
proc url_SecuritycenterOrganizationsAssetsList_594049(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SecuritycenterOrganizationsAssetsList_594048(path: JsonNode;
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
  var valid_594050 = path.getOrDefault("parent")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "parent", valid_594050
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
  var valid_594051 = query.getOrDefault("upload_protocol")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "upload_protocol", valid_594051
  var valid_594052 = query.getOrDefault("fields")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "fields", valid_594052
  var valid_594053 = query.getOrDefault("pageToken")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "pageToken", valid_594053
  var valid_594054 = query.getOrDefault("quotaUser")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "quotaUser", valid_594054
  var valid_594055 = query.getOrDefault("alt")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = newJString("json"))
  if valid_594055 != nil:
    section.add "alt", valid_594055
  var valid_594056 = query.getOrDefault("readTime")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "readTime", valid_594056
  var valid_594057 = query.getOrDefault("oauth_token")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "oauth_token", valid_594057
  var valid_594058 = query.getOrDefault("callback")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "callback", valid_594058
  var valid_594059 = query.getOrDefault("access_token")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "access_token", valid_594059
  var valid_594060 = query.getOrDefault("uploadType")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "uploadType", valid_594060
  var valid_594061 = query.getOrDefault("orderBy")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "orderBy", valid_594061
  var valid_594062 = query.getOrDefault("key")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "key", valid_594062
  var valid_594063 = query.getOrDefault("fieldMask")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "fieldMask", valid_594063
  var valid_594064 = query.getOrDefault("$.xgafv")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = newJString("1"))
  if valid_594064 != nil:
    section.add "$.xgafv", valid_594064
  var valid_594065 = query.getOrDefault("compareDuration")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "compareDuration", valid_594065
  var valid_594066 = query.getOrDefault("pageSize")
  valid_594066 = validateParameter(valid_594066, JInt, required = false, default = nil)
  if valid_594066 != nil:
    section.add "pageSize", valid_594066
  var valid_594067 = query.getOrDefault("prettyPrint")
  valid_594067 = validateParameter(valid_594067, JBool, required = false,
                                 default = newJBool(true))
  if valid_594067 != nil:
    section.add "prettyPrint", valid_594067
  var valid_594068 = query.getOrDefault("filter")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "filter", valid_594068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594069: Call_SecuritycenterOrganizationsAssetsList_594047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists an organization's assets.
  ## 
  let valid = call_594069.validator(path, query, header, formData, body)
  let scheme = call_594069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594069.url(scheme.get, call_594069.host, call_594069.base,
                         call_594069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594069, url, valid)

proc call*(call_594070: Call_SecuritycenterOrganizationsAssetsList_594047;
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
  var path_594071 = newJObject()
  var query_594072 = newJObject()
  add(query_594072, "upload_protocol", newJString(uploadProtocol))
  add(query_594072, "fields", newJString(fields))
  add(query_594072, "pageToken", newJString(pageToken))
  add(query_594072, "quotaUser", newJString(quotaUser))
  add(query_594072, "alt", newJString(alt))
  add(query_594072, "readTime", newJString(readTime))
  add(query_594072, "oauth_token", newJString(oauthToken))
  add(query_594072, "callback", newJString(callback))
  add(query_594072, "access_token", newJString(accessToken))
  add(query_594072, "uploadType", newJString(uploadType))
  add(path_594071, "parent", newJString(parent))
  add(query_594072, "orderBy", newJString(orderBy))
  add(query_594072, "key", newJString(key))
  add(query_594072, "fieldMask", newJString(fieldMask))
  add(query_594072, "$.xgafv", newJString(Xgafv))
  add(query_594072, "compareDuration", newJString(compareDuration))
  add(query_594072, "pageSize", newJInt(pageSize))
  add(query_594072, "prettyPrint", newJBool(prettyPrint))
  add(query_594072, "filter", newJString(filter))
  result = call_594070.call(path_594071, query_594072, nil, nil, nil)

var securitycenterOrganizationsAssetsList* = Call_SecuritycenterOrganizationsAssetsList_594047(
    name: "securitycenterOrganizationsAssetsList", meth: HttpMethod.HttpGet,
    host: "securitycenter.googleapis.com", route: "/v1/{parent}/assets",
    validator: validate_SecuritycenterOrganizationsAssetsList_594048, base: "/",
    url: url_SecuritycenterOrganizationsAssetsList_594049, schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsGroup_594073 = ref object of OpenApiRestCall_593408
proc url_SecuritycenterOrganizationsAssetsGroup_594075(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SecuritycenterOrganizationsAssetsGroup_594074(path: JsonNode;
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
  var valid_594076 = path.getOrDefault("parent")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "parent", valid_594076
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
  var valid_594077 = query.getOrDefault("upload_protocol")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "upload_protocol", valid_594077
  var valid_594078 = query.getOrDefault("fields")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "fields", valid_594078
  var valid_594079 = query.getOrDefault("quotaUser")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "quotaUser", valid_594079
  var valid_594080 = query.getOrDefault("alt")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = newJString("json"))
  if valid_594080 != nil:
    section.add "alt", valid_594080
  var valid_594081 = query.getOrDefault("oauth_token")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "oauth_token", valid_594081
  var valid_594082 = query.getOrDefault("callback")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "callback", valid_594082
  var valid_594083 = query.getOrDefault("access_token")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "access_token", valid_594083
  var valid_594084 = query.getOrDefault("uploadType")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "uploadType", valid_594084
  var valid_594085 = query.getOrDefault("key")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "key", valid_594085
  var valid_594086 = query.getOrDefault("$.xgafv")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = newJString("1"))
  if valid_594086 != nil:
    section.add "$.xgafv", valid_594086
  var valid_594087 = query.getOrDefault("prettyPrint")
  valid_594087 = validateParameter(valid_594087, JBool, required = false,
                                 default = newJBool(true))
  if valid_594087 != nil:
    section.add "prettyPrint", valid_594087
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

proc call*(call_594089: Call_SecuritycenterOrganizationsAssetsGroup_594073;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Filters an organization's assets and  groups them by their specified
  ## properties.
  ## 
  let valid = call_594089.validator(path, query, header, formData, body)
  let scheme = call_594089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594089.url(scheme.get, call_594089.host, call_594089.base,
                         call_594089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594089, url, valid)

proc call*(call_594090: Call_SecuritycenterOrganizationsAssetsGroup_594073;
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
  var path_594091 = newJObject()
  var query_594092 = newJObject()
  var body_594093 = newJObject()
  add(query_594092, "upload_protocol", newJString(uploadProtocol))
  add(query_594092, "fields", newJString(fields))
  add(query_594092, "quotaUser", newJString(quotaUser))
  add(query_594092, "alt", newJString(alt))
  add(query_594092, "oauth_token", newJString(oauthToken))
  add(query_594092, "callback", newJString(callback))
  add(query_594092, "access_token", newJString(accessToken))
  add(query_594092, "uploadType", newJString(uploadType))
  add(path_594091, "parent", newJString(parent))
  add(query_594092, "key", newJString(key))
  add(query_594092, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594093 = body
  add(query_594092, "prettyPrint", newJBool(prettyPrint))
  result = call_594090.call(path_594091, query_594092, nil, nil, body_594093)

var securitycenterOrganizationsAssetsGroup* = Call_SecuritycenterOrganizationsAssetsGroup_594073(
    name: "securitycenterOrganizationsAssetsGroup", meth: HttpMethod.HttpPost,
    host: "securitycenter.googleapis.com", route: "/v1/{parent}/assets:group",
    validator: validate_SecuritycenterOrganizationsAssetsGroup_594074, base: "/",
    url: url_SecuritycenterOrganizationsAssetsGroup_594075,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsRunDiscovery_594094 = ref object of OpenApiRestCall_593408
proc url_SecuritycenterOrganizationsAssetsRunDiscovery_594096(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SecuritycenterOrganizationsAssetsRunDiscovery_594095(
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
  var valid_594097 = path.getOrDefault("parent")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "parent", valid_594097
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
  var valid_594098 = query.getOrDefault("upload_protocol")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "upload_protocol", valid_594098
  var valid_594099 = query.getOrDefault("fields")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "fields", valid_594099
  var valid_594100 = query.getOrDefault("quotaUser")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "quotaUser", valid_594100
  var valid_594101 = query.getOrDefault("alt")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = newJString("json"))
  if valid_594101 != nil:
    section.add "alt", valid_594101
  var valid_594102 = query.getOrDefault("oauth_token")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "oauth_token", valid_594102
  var valid_594103 = query.getOrDefault("callback")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "callback", valid_594103
  var valid_594104 = query.getOrDefault("access_token")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "access_token", valid_594104
  var valid_594105 = query.getOrDefault("uploadType")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "uploadType", valid_594105
  var valid_594106 = query.getOrDefault("key")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "key", valid_594106
  var valid_594107 = query.getOrDefault("$.xgafv")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = newJString("1"))
  if valid_594107 != nil:
    section.add "$.xgafv", valid_594107
  var valid_594108 = query.getOrDefault("prettyPrint")
  valid_594108 = validateParameter(valid_594108, JBool, required = false,
                                 default = newJBool(true))
  if valid_594108 != nil:
    section.add "prettyPrint", valid_594108
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

proc call*(call_594110: Call_SecuritycenterOrganizationsAssetsRunDiscovery_594094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs asset discovery. The discovery is tracked with a long-running
  ## operation.
  ## 
  ## This API can only be called with limited frequency for an organization. If
  ## it is called too frequently the caller will receive a TOO_MANY_REQUESTS
  ## error.
  ## 
  let valid = call_594110.validator(path, query, header, formData, body)
  let scheme = call_594110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594110.url(scheme.get, call_594110.host, call_594110.base,
                         call_594110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594110, url, valid)

proc call*(call_594111: Call_SecuritycenterOrganizationsAssetsRunDiscovery_594094;
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
  var path_594112 = newJObject()
  var query_594113 = newJObject()
  var body_594114 = newJObject()
  add(query_594113, "upload_protocol", newJString(uploadProtocol))
  add(query_594113, "fields", newJString(fields))
  add(query_594113, "quotaUser", newJString(quotaUser))
  add(query_594113, "alt", newJString(alt))
  add(query_594113, "oauth_token", newJString(oauthToken))
  add(query_594113, "callback", newJString(callback))
  add(query_594113, "access_token", newJString(accessToken))
  add(query_594113, "uploadType", newJString(uploadType))
  add(path_594112, "parent", newJString(parent))
  add(query_594113, "key", newJString(key))
  add(query_594113, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594114 = body
  add(query_594113, "prettyPrint", newJBool(prettyPrint))
  result = call_594111.call(path_594112, query_594113, nil, nil, body_594114)

var securitycenterOrganizationsAssetsRunDiscovery* = Call_SecuritycenterOrganizationsAssetsRunDiscovery_594094(
    name: "securitycenterOrganizationsAssetsRunDiscovery",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{parent}/assets:runDiscovery",
    validator: validate_SecuritycenterOrganizationsAssetsRunDiscovery_594095,
    base: "/", url: url_SecuritycenterOrganizationsAssetsRunDiscovery_594096,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsCreate_594141 = ref object of OpenApiRestCall_593408
proc url_SecuritycenterOrganizationsSourcesFindingsCreate_594143(
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
               (kind: ConstantSegment, value: "/findings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesFindingsCreate_594142(
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
  var valid_594144 = path.getOrDefault("parent")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "parent", valid_594144
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
  var valid_594145 = query.getOrDefault("upload_protocol")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "upload_protocol", valid_594145
  var valid_594146 = query.getOrDefault("fields")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "fields", valid_594146
  var valid_594147 = query.getOrDefault("quotaUser")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "quotaUser", valid_594147
  var valid_594148 = query.getOrDefault("findingId")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "findingId", valid_594148
  var valid_594149 = query.getOrDefault("alt")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = newJString("json"))
  if valid_594149 != nil:
    section.add "alt", valid_594149
  var valid_594150 = query.getOrDefault("oauth_token")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "oauth_token", valid_594150
  var valid_594151 = query.getOrDefault("callback")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "callback", valid_594151
  var valid_594152 = query.getOrDefault("access_token")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "access_token", valid_594152
  var valid_594153 = query.getOrDefault("uploadType")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "uploadType", valid_594153
  var valid_594154 = query.getOrDefault("key")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "key", valid_594154
  var valid_594155 = query.getOrDefault("$.xgafv")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = newJString("1"))
  if valid_594155 != nil:
    section.add "$.xgafv", valid_594155
  var valid_594156 = query.getOrDefault("prettyPrint")
  valid_594156 = validateParameter(valid_594156, JBool, required = false,
                                 default = newJBool(true))
  if valid_594156 != nil:
    section.add "prettyPrint", valid_594156
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

proc call*(call_594158: Call_SecuritycenterOrganizationsSourcesFindingsCreate_594141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a finding. The corresponding source must exist for finding creation
  ## to succeed.
  ## 
  let valid = call_594158.validator(path, query, header, formData, body)
  let scheme = call_594158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594158.url(scheme.get, call_594158.host, call_594158.base,
                         call_594158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594158, url, valid)

proc call*(call_594159: Call_SecuritycenterOrganizationsSourcesFindingsCreate_594141;
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
  var path_594160 = newJObject()
  var query_594161 = newJObject()
  var body_594162 = newJObject()
  add(query_594161, "upload_protocol", newJString(uploadProtocol))
  add(query_594161, "fields", newJString(fields))
  add(query_594161, "quotaUser", newJString(quotaUser))
  add(query_594161, "findingId", newJString(findingId))
  add(query_594161, "alt", newJString(alt))
  add(query_594161, "oauth_token", newJString(oauthToken))
  add(query_594161, "callback", newJString(callback))
  add(query_594161, "access_token", newJString(accessToken))
  add(query_594161, "uploadType", newJString(uploadType))
  add(path_594160, "parent", newJString(parent))
  add(query_594161, "key", newJString(key))
  add(query_594161, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594162 = body
  add(query_594161, "prettyPrint", newJBool(prettyPrint))
  result = call_594159.call(path_594160, query_594161, nil, nil, body_594162)

var securitycenterOrganizationsSourcesFindingsCreate* = Call_SecuritycenterOrganizationsSourcesFindingsCreate_594141(
    name: "securitycenterOrganizationsSourcesFindingsCreate",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{parent}/findings",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsCreate_594142,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsCreate_594143,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsList_594115 = ref object of OpenApiRestCall_593408
proc url_SecuritycenterOrganizationsSourcesFindingsList_594117(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SecuritycenterOrganizationsSourcesFindingsList_594116(
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
  var valid_594118 = path.getOrDefault("parent")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "parent", valid_594118
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
  var valid_594119 = query.getOrDefault("upload_protocol")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "upload_protocol", valid_594119
  var valid_594120 = query.getOrDefault("fields")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "fields", valid_594120
  var valid_594121 = query.getOrDefault("pageToken")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "pageToken", valid_594121
  var valid_594122 = query.getOrDefault("quotaUser")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "quotaUser", valid_594122
  var valid_594123 = query.getOrDefault("alt")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = newJString("json"))
  if valid_594123 != nil:
    section.add "alt", valid_594123
  var valid_594124 = query.getOrDefault("readTime")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "readTime", valid_594124
  var valid_594125 = query.getOrDefault("oauth_token")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "oauth_token", valid_594125
  var valid_594126 = query.getOrDefault("callback")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "callback", valid_594126
  var valid_594127 = query.getOrDefault("access_token")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "access_token", valid_594127
  var valid_594128 = query.getOrDefault("uploadType")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "uploadType", valid_594128
  var valid_594129 = query.getOrDefault("orderBy")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "orderBy", valid_594129
  var valid_594130 = query.getOrDefault("key")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "key", valid_594130
  var valid_594131 = query.getOrDefault("fieldMask")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "fieldMask", valid_594131
  var valid_594132 = query.getOrDefault("$.xgafv")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = newJString("1"))
  if valid_594132 != nil:
    section.add "$.xgafv", valid_594132
  var valid_594133 = query.getOrDefault("compareDuration")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "compareDuration", valid_594133
  var valid_594134 = query.getOrDefault("pageSize")
  valid_594134 = validateParameter(valid_594134, JInt, required = false, default = nil)
  if valid_594134 != nil:
    section.add "pageSize", valid_594134
  var valid_594135 = query.getOrDefault("prettyPrint")
  valid_594135 = validateParameter(valid_594135, JBool, required = false,
                                 default = newJBool(true))
  if valid_594135 != nil:
    section.add "prettyPrint", valid_594135
  var valid_594136 = query.getOrDefault("filter")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "filter", valid_594136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594137: Call_SecuritycenterOrganizationsSourcesFindingsList_594115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists an organization or source's findings.
  ## 
  ## To list across all sources provide a `-` as the source id.
  ## Example: /v1/organizations/123/sources/-/findings
  ## 
  let valid = call_594137.validator(path, query, header, formData, body)
  let scheme = call_594137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594137.url(scheme.get, call_594137.host, call_594137.base,
                         call_594137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594137, url, valid)

proc call*(call_594138: Call_SecuritycenterOrganizationsSourcesFindingsList_594115;
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
  var path_594139 = newJObject()
  var query_594140 = newJObject()
  add(query_594140, "upload_protocol", newJString(uploadProtocol))
  add(query_594140, "fields", newJString(fields))
  add(query_594140, "pageToken", newJString(pageToken))
  add(query_594140, "quotaUser", newJString(quotaUser))
  add(query_594140, "alt", newJString(alt))
  add(query_594140, "readTime", newJString(readTime))
  add(query_594140, "oauth_token", newJString(oauthToken))
  add(query_594140, "callback", newJString(callback))
  add(query_594140, "access_token", newJString(accessToken))
  add(query_594140, "uploadType", newJString(uploadType))
  add(path_594139, "parent", newJString(parent))
  add(query_594140, "orderBy", newJString(orderBy))
  add(query_594140, "key", newJString(key))
  add(query_594140, "fieldMask", newJString(fieldMask))
  add(query_594140, "$.xgafv", newJString(Xgafv))
  add(query_594140, "compareDuration", newJString(compareDuration))
  add(query_594140, "pageSize", newJInt(pageSize))
  add(query_594140, "prettyPrint", newJBool(prettyPrint))
  add(query_594140, "filter", newJString(filter))
  result = call_594138.call(path_594139, query_594140, nil, nil, nil)

var securitycenterOrganizationsSourcesFindingsList* = Call_SecuritycenterOrganizationsSourcesFindingsList_594115(
    name: "securitycenterOrganizationsSourcesFindingsList",
    meth: HttpMethod.HttpGet, host: "securitycenter.googleapis.com",
    route: "/v1/{parent}/findings",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsList_594116,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsList_594117,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsGroup_594163 = ref object of OpenApiRestCall_593408
proc url_SecuritycenterOrganizationsSourcesFindingsGroup_594165(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SecuritycenterOrganizationsSourcesFindingsGroup_594164(
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
  var valid_594166 = path.getOrDefault("parent")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "parent", valid_594166
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
  var valid_594167 = query.getOrDefault("upload_protocol")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "upload_protocol", valid_594167
  var valid_594168 = query.getOrDefault("fields")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "fields", valid_594168
  var valid_594169 = query.getOrDefault("quotaUser")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "quotaUser", valid_594169
  var valid_594170 = query.getOrDefault("alt")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = newJString("json"))
  if valid_594170 != nil:
    section.add "alt", valid_594170
  var valid_594171 = query.getOrDefault("oauth_token")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "oauth_token", valid_594171
  var valid_594172 = query.getOrDefault("callback")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "callback", valid_594172
  var valid_594173 = query.getOrDefault("access_token")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "access_token", valid_594173
  var valid_594174 = query.getOrDefault("uploadType")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "uploadType", valid_594174
  var valid_594175 = query.getOrDefault("key")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "key", valid_594175
  var valid_594176 = query.getOrDefault("$.xgafv")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = newJString("1"))
  if valid_594176 != nil:
    section.add "$.xgafv", valid_594176
  var valid_594177 = query.getOrDefault("prettyPrint")
  valid_594177 = validateParameter(valid_594177, JBool, required = false,
                                 default = newJBool(true))
  if valid_594177 != nil:
    section.add "prettyPrint", valid_594177
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

proc call*(call_594179: Call_SecuritycenterOrganizationsSourcesFindingsGroup_594163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Filters an organization or source's findings and  groups them by their
  ## specified properties.
  ## 
  ## To group across all sources provide a `-` as the source id.
  ## Example: /v1/organizations/123/sources/-/findings
  ## 
  let valid = call_594179.validator(path, query, header, formData, body)
  let scheme = call_594179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594179.url(scheme.get, call_594179.host, call_594179.base,
                         call_594179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594179, url, valid)

proc call*(call_594180: Call_SecuritycenterOrganizationsSourcesFindingsGroup_594163;
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
  var path_594181 = newJObject()
  var query_594182 = newJObject()
  var body_594183 = newJObject()
  add(query_594182, "upload_protocol", newJString(uploadProtocol))
  add(query_594182, "fields", newJString(fields))
  add(query_594182, "quotaUser", newJString(quotaUser))
  add(query_594182, "alt", newJString(alt))
  add(query_594182, "oauth_token", newJString(oauthToken))
  add(query_594182, "callback", newJString(callback))
  add(query_594182, "access_token", newJString(accessToken))
  add(query_594182, "uploadType", newJString(uploadType))
  add(path_594181, "parent", newJString(parent))
  add(query_594182, "key", newJString(key))
  add(query_594182, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594183 = body
  add(query_594182, "prettyPrint", newJBool(prettyPrint))
  result = call_594180.call(path_594181, query_594182, nil, nil, body_594183)

var securitycenterOrganizationsSourcesFindingsGroup* = Call_SecuritycenterOrganizationsSourcesFindingsGroup_594163(
    name: "securitycenterOrganizationsSourcesFindingsGroup",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{parent}/findings:group",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsGroup_594164,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsGroup_594165,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesCreate_594205 = ref object of OpenApiRestCall_593408
proc url_SecuritycenterOrganizationsSourcesCreate_594207(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SecuritycenterOrganizationsSourcesCreate_594206(path: JsonNode;
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
  var valid_594208 = path.getOrDefault("parent")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "parent", valid_594208
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
  var valid_594209 = query.getOrDefault("upload_protocol")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "upload_protocol", valid_594209
  var valid_594210 = query.getOrDefault("fields")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "fields", valid_594210
  var valid_594211 = query.getOrDefault("quotaUser")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "quotaUser", valid_594211
  var valid_594212 = query.getOrDefault("alt")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = newJString("json"))
  if valid_594212 != nil:
    section.add "alt", valid_594212
  var valid_594213 = query.getOrDefault("oauth_token")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = nil)
  if valid_594213 != nil:
    section.add "oauth_token", valid_594213
  var valid_594214 = query.getOrDefault("callback")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "callback", valid_594214
  var valid_594215 = query.getOrDefault("access_token")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "access_token", valid_594215
  var valid_594216 = query.getOrDefault("uploadType")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "uploadType", valid_594216
  var valid_594217 = query.getOrDefault("key")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "key", valid_594217
  var valid_594218 = query.getOrDefault("$.xgafv")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = newJString("1"))
  if valid_594218 != nil:
    section.add "$.xgafv", valid_594218
  var valid_594219 = query.getOrDefault("prettyPrint")
  valid_594219 = validateParameter(valid_594219, JBool, required = false,
                                 default = newJBool(true))
  if valid_594219 != nil:
    section.add "prettyPrint", valid_594219
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

proc call*(call_594221: Call_SecuritycenterOrganizationsSourcesCreate_594205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a source.
  ## 
  let valid = call_594221.validator(path, query, header, formData, body)
  let scheme = call_594221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594221.url(scheme.get, call_594221.host, call_594221.base,
                         call_594221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594221, url, valid)

proc call*(call_594222: Call_SecuritycenterOrganizationsSourcesCreate_594205;
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
  var path_594223 = newJObject()
  var query_594224 = newJObject()
  var body_594225 = newJObject()
  add(query_594224, "upload_protocol", newJString(uploadProtocol))
  add(query_594224, "fields", newJString(fields))
  add(query_594224, "quotaUser", newJString(quotaUser))
  add(query_594224, "alt", newJString(alt))
  add(query_594224, "oauth_token", newJString(oauthToken))
  add(query_594224, "callback", newJString(callback))
  add(query_594224, "access_token", newJString(accessToken))
  add(query_594224, "uploadType", newJString(uploadType))
  add(path_594223, "parent", newJString(parent))
  add(query_594224, "key", newJString(key))
  add(query_594224, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594225 = body
  add(query_594224, "prettyPrint", newJBool(prettyPrint))
  result = call_594222.call(path_594223, query_594224, nil, nil, body_594225)

var securitycenterOrganizationsSourcesCreate* = Call_SecuritycenterOrganizationsSourcesCreate_594205(
    name: "securitycenterOrganizationsSourcesCreate", meth: HttpMethod.HttpPost,
    host: "securitycenter.googleapis.com", route: "/v1/{parent}/sources",
    validator: validate_SecuritycenterOrganizationsSourcesCreate_594206,
    base: "/", url: url_SecuritycenterOrganizationsSourcesCreate_594207,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesList_594184 = ref object of OpenApiRestCall_593408
proc url_SecuritycenterOrganizationsSourcesList_594186(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SecuritycenterOrganizationsSourcesList_594185(path: JsonNode;
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
  var valid_594187 = path.getOrDefault("parent")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "parent", valid_594187
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
  var valid_594188 = query.getOrDefault("upload_protocol")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "upload_protocol", valid_594188
  var valid_594189 = query.getOrDefault("fields")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "fields", valid_594189
  var valid_594190 = query.getOrDefault("pageToken")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "pageToken", valid_594190
  var valid_594191 = query.getOrDefault("quotaUser")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "quotaUser", valid_594191
  var valid_594192 = query.getOrDefault("alt")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = newJString("json"))
  if valid_594192 != nil:
    section.add "alt", valid_594192
  var valid_594193 = query.getOrDefault("oauth_token")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "oauth_token", valid_594193
  var valid_594194 = query.getOrDefault("callback")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "callback", valid_594194
  var valid_594195 = query.getOrDefault("access_token")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "access_token", valid_594195
  var valid_594196 = query.getOrDefault("uploadType")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "uploadType", valid_594196
  var valid_594197 = query.getOrDefault("key")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "key", valid_594197
  var valid_594198 = query.getOrDefault("$.xgafv")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = newJString("1"))
  if valid_594198 != nil:
    section.add "$.xgafv", valid_594198
  var valid_594199 = query.getOrDefault("pageSize")
  valid_594199 = validateParameter(valid_594199, JInt, required = false, default = nil)
  if valid_594199 != nil:
    section.add "pageSize", valid_594199
  var valid_594200 = query.getOrDefault("prettyPrint")
  valid_594200 = validateParameter(valid_594200, JBool, required = false,
                                 default = newJBool(true))
  if valid_594200 != nil:
    section.add "prettyPrint", valid_594200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594201: Call_SecuritycenterOrganizationsSourcesList_594184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all sources belonging to an organization.
  ## 
  let valid = call_594201.validator(path, query, header, formData, body)
  let scheme = call_594201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594201.url(scheme.get, call_594201.host, call_594201.base,
                         call_594201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594201, url, valid)

proc call*(call_594202: Call_SecuritycenterOrganizationsSourcesList_594184;
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
  var path_594203 = newJObject()
  var query_594204 = newJObject()
  add(query_594204, "upload_protocol", newJString(uploadProtocol))
  add(query_594204, "fields", newJString(fields))
  add(query_594204, "pageToken", newJString(pageToken))
  add(query_594204, "quotaUser", newJString(quotaUser))
  add(query_594204, "alt", newJString(alt))
  add(query_594204, "oauth_token", newJString(oauthToken))
  add(query_594204, "callback", newJString(callback))
  add(query_594204, "access_token", newJString(accessToken))
  add(query_594204, "uploadType", newJString(uploadType))
  add(path_594203, "parent", newJString(parent))
  add(query_594204, "key", newJString(key))
  add(query_594204, "$.xgafv", newJString(Xgafv))
  add(query_594204, "pageSize", newJInt(pageSize))
  add(query_594204, "prettyPrint", newJBool(prettyPrint))
  result = call_594202.call(path_594203, query_594204, nil, nil, nil)

var securitycenterOrganizationsSourcesList* = Call_SecuritycenterOrganizationsSourcesList_594184(
    name: "securitycenterOrganizationsSourcesList", meth: HttpMethod.HttpGet,
    host: "securitycenter.googleapis.com", route: "/v1/{parent}/sources",
    validator: validate_SecuritycenterOrganizationsSourcesList_594185, base: "/",
    url: url_SecuritycenterOrganizationsSourcesList_594186,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesGetIamPolicy_594226 = ref object of OpenApiRestCall_593408
proc url_SecuritycenterOrganizationsSourcesGetIamPolicy_594228(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SecuritycenterOrganizationsSourcesGetIamPolicy_594227(
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
  var valid_594229 = path.getOrDefault("resource")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "resource", valid_594229
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
  var valid_594230 = query.getOrDefault("upload_protocol")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "upload_protocol", valid_594230
  var valid_594231 = query.getOrDefault("fields")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "fields", valid_594231
  var valid_594232 = query.getOrDefault("quotaUser")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "quotaUser", valid_594232
  var valid_594233 = query.getOrDefault("alt")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = newJString("json"))
  if valid_594233 != nil:
    section.add "alt", valid_594233
  var valid_594234 = query.getOrDefault("oauth_token")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "oauth_token", valid_594234
  var valid_594235 = query.getOrDefault("callback")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "callback", valid_594235
  var valid_594236 = query.getOrDefault("access_token")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "access_token", valid_594236
  var valid_594237 = query.getOrDefault("uploadType")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "uploadType", valid_594237
  var valid_594238 = query.getOrDefault("key")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = nil)
  if valid_594238 != nil:
    section.add "key", valid_594238
  var valid_594239 = query.getOrDefault("$.xgafv")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = newJString("1"))
  if valid_594239 != nil:
    section.add "$.xgafv", valid_594239
  var valid_594240 = query.getOrDefault("prettyPrint")
  valid_594240 = validateParameter(valid_594240, JBool, required = false,
                                 default = newJBool(true))
  if valid_594240 != nil:
    section.add "prettyPrint", valid_594240
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

proc call*(call_594242: Call_SecuritycenterOrganizationsSourcesGetIamPolicy_594226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy on the specified Source.
  ## 
  let valid = call_594242.validator(path, query, header, formData, body)
  let scheme = call_594242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594242.url(scheme.get, call_594242.host, call_594242.base,
                         call_594242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594242, url, valid)

proc call*(call_594243: Call_SecuritycenterOrganizationsSourcesGetIamPolicy_594226;
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
  var path_594244 = newJObject()
  var query_594245 = newJObject()
  var body_594246 = newJObject()
  add(query_594245, "upload_protocol", newJString(uploadProtocol))
  add(query_594245, "fields", newJString(fields))
  add(query_594245, "quotaUser", newJString(quotaUser))
  add(query_594245, "alt", newJString(alt))
  add(query_594245, "oauth_token", newJString(oauthToken))
  add(query_594245, "callback", newJString(callback))
  add(query_594245, "access_token", newJString(accessToken))
  add(query_594245, "uploadType", newJString(uploadType))
  add(query_594245, "key", newJString(key))
  add(query_594245, "$.xgafv", newJString(Xgafv))
  add(path_594244, "resource", newJString(resource))
  if body != nil:
    body_594246 = body
  add(query_594245, "prettyPrint", newJBool(prettyPrint))
  result = call_594243.call(path_594244, query_594245, nil, nil, body_594246)

var securitycenterOrganizationsSourcesGetIamPolicy* = Call_SecuritycenterOrganizationsSourcesGetIamPolicy_594226(
    name: "securitycenterOrganizationsSourcesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_SecuritycenterOrganizationsSourcesGetIamPolicy_594227,
    base: "/", url: url_SecuritycenterOrganizationsSourcesGetIamPolicy_594228,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesSetIamPolicy_594247 = ref object of OpenApiRestCall_593408
proc url_SecuritycenterOrganizationsSourcesSetIamPolicy_594249(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SecuritycenterOrganizationsSourcesSetIamPolicy_594248(
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
  var valid_594250 = path.getOrDefault("resource")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "resource", valid_594250
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
  var valid_594251 = query.getOrDefault("upload_protocol")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = nil)
  if valid_594251 != nil:
    section.add "upload_protocol", valid_594251
  var valid_594252 = query.getOrDefault("fields")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = nil)
  if valid_594252 != nil:
    section.add "fields", valid_594252
  var valid_594253 = query.getOrDefault("quotaUser")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "quotaUser", valid_594253
  var valid_594254 = query.getOrDefault("alt")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = newJString("json"))
  if valid_594254 != nil:
    section.add "alt", valid_594254
  var valid_594255 = query.getOrDefault("oauth_token")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "oauth_token", valid_594255
  var valid_594256 = query.getOrDefault("callback")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "callback", valid_594256
  var valid_594257 = query.getOrDefault("access_token")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "access_token", valid_594257
  var valid_594258 = query.getOrDefault("uploadType")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "uploadType", valid_594258
  var valid_594259 = query.getOrDefault("key")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "key", valid_594259
  var valid_594260 = query.getOrDefault("$.xgafv")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = newJString("1"))
  if valid_594260 != nil:
    section.add "$.xgafv", valid_594260
  var valid_594261 = query.getOrDefault("prettyPrint")
  valid_594261 = validateParameter(valid_594261, JBool, required = false,
                                 default = newJBool(true))
  if valid_594261 != nil:
    section.add "prettyPrint", valid_594261
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

proc call*(call_594263: Call_SecuritycenterOrganizationsSourcesSetIamPolicy_594247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified Source.
  ## 
  let valid = call_594263.validator(path, query, header, formData, body)
  let scheme = call_594263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594263.url(scheme.get, call_594263.host, call_594263.base,
                         call_594263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594263, url, valid)

proc call*(call_594264: Call_SecuritycenterOrganizationsSourcesSetIamPolicy_594247;
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
  var path_594265 = newJObject()
  var query_594266 = newJObject()
  var body_594267 = newJObject()
  add(query_594266, "upload_protocol", newJString(uploadProtocol))
  add(query_594266, "fields", newJString(fields))
  add(query_594266, "quotaUser", newJString(quotaUser))
  add(query_594266, "alt", newJString(alt))
  add(query_594266, "oauth_token", newJString(oauthToken))
  add(query_594266, "callback", newJString(callback))
  add(query_594266, "access_token", newJString(accessToken))
  add(query_594266, "uploadType", newJString(uploadType))
  add(query_594266, "key", newJString(key))
  add(query_594266, "$.xgafv", newJString(Xgafv))
  add(path_594265, "resource", newJString(resource))
  if body != nil:
    body_594267 = body
  add(query_594266, "prettyPrint", newJBool(prettyPrint))
  result = call_594264.call(path_594265, query_594266, nil, nil, body_594267)

var securitycenterOrganizationsSourcesSetIamPolicy* = Call_SecuritycenterOrganizationsSourcesSetIamPolicy_594247(
    name: "securitycenterOrganizationsSourcesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_SecuritycenterOrganizationsSourcesSetIamPolicy_594248,
    base: "/", url: url_SecuritycenterOrganizationsSourcesSetIamPolicy_594249,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesTestIamPermissions_594268 = ref object of OpenApiRestCall_593408
proc url_SecuritycenterOrganizationsSourcesTestIamPermissions_594270(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_SecuritycenterOrganizationsSourcesTestIamPermissions_594269(
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
  var valid_594271 = path.getOrDefault("resource")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "resource", valid_594271
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
  var valid_594272 = query.getOrDefault("upload_protocol")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = nil)
  if valid_594272 != nil:
    section.add "upload_protocol", valid_594272
  var valid_594273 = query.getOrDefault("fields")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = nil)
  if valid_594273 != nil:
    section.add "fields", valid_594273
  var valid_594274 = query.getOrDefault("quotaUser")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "quotaUser", valid_594274
  var valid_594275 = query.getOrDefault("alt")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = newJString("json"))
  if valid_594275 != nil:
    section.add "alt", valid_594275
  var valid_594276 = query.getOrDefault("oauth_token")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "oauth_token", valid_594276
  var valid_594277 = query.getOrDefault("callback")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "callback", valid_594277
  var valid_594278 = query.getOrDefault("access_token")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "access_token", valid_594278
  var valid_594279 = query.getOrDefault("uploadType")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "uploadType", valid_594279
  var valid_594280 = query.getOrDefault("key")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "key", valid_594280
  var valid_594281 = query.getOrDefault("$.xgafv")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = newJString("1"))
  if valid_594281 != nil:
    section.add "$.xgafv", valid_594281
  var valid_594282 = query.getOrDefault("prettyPrint")
  valid_594282 = validateParameter(valid_594282, JBool, required = false,
                                 default = newJBool(true))
  if valid_594282 != nil:
    section.add "prettyPrint", valid_594282
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

proc call*(call_594284: Call_SecuritycenterOrganizationsSourcesTestIamPermissions_594268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the permissions that a caller has on the specified source.
  ## 
  let valid = call_594284.validator(path, query, header, formData, body)
  let scheme = call_594284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594284.url(scheme.get, call_594284.host, call_594284.base,
                         call_594284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594284, url, valid)

proc call*(call_594285: Call_SecuritycenterOrganizationsSourcesTestIamPermissions_594268;
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
  var path_594286 = newJObject()
  var query_594287 = newJObject()
  var body_594288 = newJObject()
  add(query_594287, "upload_protocol", newJString(uploadProtocol))
  add(query_594287, "fields", newJString(fields))
  add(query_594287, "quotaUser", newJString(quotaUser))
  add(query_594287, "alt", newJString(alt))
  add(query_594287, "oauth_token", newJString(oauthToken))
  add(query_594287, "callback", newJString(callback))
  add(query_594287, "access_token", newJString(accessToken))
  add(query_594287, "uploadType", newJString(uploadType))
  add(query_594287, "key", newJString(key))
  add(query_594287, "$.xgafv", newJString(Xgafv))
  add(path_594286, "resource", newJString(resource))
  if body != nil:
    body_594288 = body
  add(query_594287, "prettyPrint", newJBool(prettyPrint))
  result = call_594285.call(path_594286, query_594287, nil, nil, body_594288)

var securitycenterOrganizationsSourcesTestIamPermissions* = Call_SecuritycenterOrganizationsSourcesTestIamPermissions_594268(
    name: "securitycenterOrganizationsSourcesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_SecuritycenterOrganizationsSourcesTestIamPermissions_594269,
    base: "/", url: url_SecuritycenterOrganizationsSourcesTestIamPermissions_594270,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
