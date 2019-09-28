
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Access Context Manager
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## An API for setting attribute based access control to requests to GCP services.
## 
## https://cloud.google.com/access-context-manager/docs/reference/rest/
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
  gcpServiceName = "accesscontextmanager"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AccesscontextmanagerAccessPoliciesCreate_579952 = ref object of OpenApiRestCall_579408
proc url_AccesscontextmanagerAccessPoliciesCreate_579954(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AccesscontextmanagerAccessPoliciesCreate_579953(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create an `AccessPolicy`. Fails if this organization already has a
  ## `AccessPolicy`. The longrunning Operation will have a successful status
  ## once the `AccessPolicy` has propagated to long-lasting storage.
  ## Syntactic and basic semantic errors will be returned in `metadata` as a
  ## BadRequest proto.
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
  var valid_579955 = query.getOrDefault("upload_protocol")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "upload_protocol", valid_579955
  var valid_579956 = query.getOrDefault("fields")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "fields", valid_579956
  var valid_579957 = query.getOrDefault("quotaUser")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "quotaUser", valid_579957
  var valid_579958 = query.getOrDefault("alt")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = newJString("json"))
  if valid_579958 != nil:
    section.add "alt", valid_579958
  var valid_579959 = query.getOrDefault("oauth_token")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "oauth_token", valid_579959
  var valid_579960 = query.getOrDefault("callback")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "callback", valid_579960
  var valid_579961 = query.getOrDefault("access_token")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "access_token", valid_579961
  var valid_579962 = query.getOrDefault("uploadType")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "uploadType", valid_579962
  var valid_579963 = query.getOrDefault("key")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "key", valid_579963
  var valid_579964 = query.getOrDefault("$.xgafv")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = newJString("1"))
  if valid_579964 != nil:
    section.add "$.xgafv", valid_579964
  var valid_579965 = query.getOrDefault("prettyPrint")
  valid_579965 = validateParameter(valid_579965, JBool, required = false,
                                 default = newJBool(true))
  if valid_579965 != nil:
    section.add "prettyPrint", valid_579965
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

proc call*(call_579967: Call_AccesscontextmanagerAccessPoliciesCreate_579952;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an `AccessPolicy`. Fails if this organization already has a
  ## `AccessPolicy`. The longrunning Operation will have a successful status
  ## once the `AccessPolicy` has propagated to long-lasting storage.
  ## Syntactic and basic semantic errors will be returned in `metadata` as a
  ## BadRequest proto.
  ## 
  let valid = call_579967.validator(path, query, header, formData, body)
  let scheme = call_579967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579967.url(scheme.get, call_579967.host, call_579967.base,
                         call_579967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579967, url, valid)

proc call*(call_579968: Call_AccesscontextmanagerAccessPoliciesCreate_579952;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## accesscontextmanagerAccessPoliciesCreate
  ## Create an `AccessPolicy`. Fails if this organization already has a
  ## `AccessPolicy`. The longrunning Operation will have a successful status
  ## once the `AccessPolicy` has propagated to long-lasting storage.
  ## Syntactic and basic semantic errors will be returned in `metadata` as a
  ## BadRequest proto.
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
  var query_579969 = newJObject()
  var body_579970 = newJObject()
  add(query_579969, "upload_protocol", newJString(uploadProtocol))
  add(query_579969, "fields", newJString(fields))
  add(query_579969, "quotaUser", newJString(quotaUser))
  add(query_579969, "alt", newJString(alt))
  add(query_579969, "oauth_token", newJString(oauthToken))
  add(query_579969, "callback", newJString(callback))
  add(query_579969, "access_token", newJString(accessToken))
  add(query_579969, "uploadType", newJString(uploadType))
  add(query_579969, "key", newJString(key))
  add(query_579969, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579970 = body
  add(query_579969, "prettyPrint", newJBool(prettyPrint))
  result = call_579968.call(nil, query_579969, nil, nil, body_579970)

var accesscontextmanagerAccessPoliciesCreate* = Call_AccesscontextmanagerAccessPoliciesCreate_579952(
    name: "accesscontextmanagerAccessPoliciesCreate", meth: HttpMethod.HttpPost,
    host: "accesscontextmanager.googleapis.com", route: "/v1/accessPolicies",
    validator: validate_AccesscontextmanagerAccessPoliciesCreate_579953,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesCreate_579954,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesList_579677 = ref object of OpenApiRestCall_579408
proc url_AccesscontextmanagerAccessPoliciesList_579679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AccesscontextmanagerAccessPoliciesList_579678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all AccessPolicies under a
  ## container.
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
  ##            : Next page token for the next batch of AccessPolicy instances. Defaults to
  ## the first page of results.
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
  ##   parent: JString
  ##         : Required. Resource name for the container to list AccessPolicy instances
  ## from.
  ## 
  ## Format:
  ## `organizations/{org_id}`
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of AccessPolicy instances to include in the list. Default 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579791 = query.getOrDefault("upload_protocol")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "upload_protocol", valid_579791
  var valid_579792 = query.getOrDefault("fields")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "fields", valid_579792
  var valid_579793 = query.getOrDefault("pageToken")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "pageToken", valid_579793
  var valid_579794 = query.getOrDefault("quotaUser")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "quotaUser", valid_579794
  var valid_579808 = query.getOrDefault("alt")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = newJString("json"))
  if valid_579808 != nil:
    section.add "alt", valid_579808
  var valid_579809 = query.getOrDefault("oauth_token")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "oauth_token", valid_579809
  var valid_579810 = query.getOrDefault("callback")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "callback", valid_579810
  var valid_579811 = query.getOrDefault("access_token")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "access_token", valid_579811
  var valid_579812 = query.getOrDefault("uploadType")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "uploadType", valid_579812
  var valid_579813 = query.getOrDefault("parent")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "parent", valid_579813
  var valid_579814 = query.getOrDefault("key")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "key", valid_579814
  var valid_579815 = query.getOrDefault("$.xgafv")
  valid_579815 = validateParameter(valid_579815, JString, required = false,
                                 default = newJString("1"))
  if valid_579815 != nil:
    section.add "$.xgafv", valid_579815
  var valid_579816 = query.getOrDefault("pageSize")
  valid_579816 = validateParameter(valid_579816, JInt, required = false, default = nil)
  if valid_579816 != nil:
    section.add "pageSize", valid_579816
  var valid_579817 = query.getOrDefault("prettyPrint")
  valid_579817 = validateParameter(valid_579817, JBool, required = false,
                                 default = newJBool(true))
  if valid_579817 != nil:
    section.add "prettyPrint", valid_579817
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579840: Call_AccesscontextmanagerAccessPoliciesList_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all AccessPolicies under a
  ## container.
  ## 
  let valid = call_579840.validator(path, query, header, formData, body)
  let scheme = call_579840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579840.url(scheme.get, call_579840.host, call_579840.base,
                         call_579840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579840, url, valid)

proc call*(call_579911: Call_AccesscontextmanagerAccessPoliciesList_579677;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          parent: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## accesscontextmanagerAccessPoliciesList
  ## List all AccessPolicies under a
  ## container.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Next page token for the next batch of AccessPolicy instances. Defaults to
  ## the first page of results.
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
  ##   parent: string
  ##         : Required. Resource name for the container to list AccessPolicy instances
  ## from.
  ## 
  ## Format:
  ## `organizations/{org_id}`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of AccessPolicy instances to include in the list. Default 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579912 = newJObject()
  add(query_579912, "upload_protocol", newJString(uploadProtocol))
  add(query_579912, "fields", newJString(fields))
  add(query_579912, "pageToken", newJString(pageToken))
  add(query_579912, "quotaUser", newJString(quotaUser))
  add(query_579912, "alt", newJString(alt))
  add(query_579912, "oauth_token", newJString(oauthToken))
  add(query_579912, "callback", newJString(callback))
  add(query_579912, "access_token", newJString(accessToken))
  add(query_579912, "uploadType", newJString(uploadType))
  add(query_579912, "parent", newJString(parent))
  add(query_579912, "key", newJString(key))
  add(query_579912, "$.xgafv", newJString(Xgafv))
  add(query_579912, "pageSize", newJInt(pageSize))
  add(query_579912, "prettyPrint", newJBool(prettyPrint))
  result = call_579911.call(nil, query_579912, nil, nil, nil)

var accesscontextmanagerAccessPoliciesList* = Call_AccesscontextmanagerAccessPoliciesList_579677(
    name: "accesscontextmanagerAccessPoliciesList", meth: HttpMethod.HttpGet,
    host: "accesscontextmanager.googleapis.com", route: "/v1/accessPolicies",
    validator: validate_AccesscontextmanagerAccessPoliciesList_579678, base: "/",
    url: url_AccesscontextmanagerAccessPoliciesList_579679,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsGet_579971 = ref object of OpenApiRestCall_579408
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsGet_579973(
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

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsGet_579972(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get an Access Level by resource
  ## name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name for the Access Level.
  ## 
  ## Format:
  ## `accessPolicies/{policy_id}/accessLevels/{access_level_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579988 = path.getOrDefault("name")
  valid_579988 = validateParameter(valid_579988, JString, required = true,
                                 default = nil)
  if valid_579988 != nil:
    section.add "name", valid_579988
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
  ##   accessLevelFormat: JString
  ##                    : Whether to return `BasicLevels` in the Cloud Common Expression
  ## Language rather than as `BasicLevels`. Defaults to AS_DEFINED, where
  ## Access Levels
  ## are returned as `BasicLevels` or `CustomLevels` based on how they were
  ## created. If set to CEL, all Access Levels are returned as
  ## `CustomLevels`. In the CEL case, `BasicLevels` are translated to equivalent
  ## `CustomLevels`.
  section = newJObject()
  var valid_579989 = query.getOrDefault("upload_protocol")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "upload_protocol", valid_579989
  var valid_579990 = query.getOrDefault("fields")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "fields", valid_579990
  var valid_579991 = query.getOrDefault("quotaUser")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "quotaUser", valid_579991
  var valid_579992 = query.getOrDefault("alt")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = newJString("json"))
  if valid_579992 != nil:
    section.add "alt", valid_579992
  var valid_579993 = query.getOrDefault("oauth_token")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "oauth_token", valid_579993
  var valid_579994 = query.getOrDefault("callback")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "callback", valid_579994
  var valid_579995 = query.getOrDefault("access_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "access_token", valid_579995
  var valid_579996 = query.getOrDefault("uploadType")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "uploadType", valid_579996
  var valid_579997 = query.getOrDefault("key")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "key", valid_579997
  var valid_579998 = query.getOrDefault("$.xgafv")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = newJString("1"))
  if valid_579998 != nil:
    section.add "$.xgafv", valid_579998
  var valid_579999 = query.getOrDefault("prettyPrint")
  valid_579999 = validateParameter(valid_579999, JBool, required = false,
                                 default = newJBool(true))
  if valid_579999 != nil:
    section.add "prettyPrint", valid_579999
  var valid_580000 = query.getOrDefault("accessLevelFormat")
  valid_580000 = validateParameter(valid_580000, JString, required = false, default = newJString(
      "LEVEL_FORMAT_UNSPECIFIED"))
  if valid_580000 != nil:
    section.add "accessLevelFormat", valid_580000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580001: Call_AccesscontextmanagerAccessPoliciesAccessLevelsGet_579971;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an Access Level by resource
  ## name.
  ## 
  let valid = call_580001.validator(path, query, header, formData, body)
  let scheme = call_580001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580001.url(scheme.get, call_580001.host, call_580001.base,
                         call_580001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580001, url, valid)

proc call*(call_580002: Call_AccesscontextmanagerAccessPoliciesAccessLevelsGet_579971;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          accessLevelFormat: string = "LEVEL_FORMAT_UNSPECIFIED"): Recallable =
  ## accesscontextmanagerAccessPoliciesAccessLevelsGet
  ## Get an Access Level by resource
  ## name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Resource name for the Access Level.
  ## 
  ## Format:
  ## `accessPolicies/{policy_id}/accessLevels/{access_level_id}`
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
  ##   accessLevelFormat: string
  ##                    : Whether to return `BasicLevels` in the Cloud Common Expression
  ## Language rather than as `BasicLevels`. Defaults to AS_DEFINED, where
  ## Access Levels
  ## are returned as `BasicLevels` or `CustomLevels` based on how they were
  ## created. If set to CEL, all Access Levels are returned as
  ## `CustomLevels`. In the CEL case, `BasicLevels` are translated to equivalent
  ## `CustomLevels`.
  var path_580003 = newJObject()
  var query_580004 = newJObject()
  add(query_580004, "upload_protocol", newJString(uploadProtocol))
  add(query_580004, "fields", newJString(fields))
  add(query_580004, "quotaUser", newJString(quotaUser))
  add(path_580003, "name", newJString(name))
  add(query_580004, "alt", newJString(alt))
  add(query_580004, "oauth_token", newJString(oauthToken))
  add(query_580004, "callback", newJString(callback))
  add(query_580004, "access_token", newJString(accessToken))
  add(query_580004, "uploadType", newJString(uploadType))
  add(query_580004, "key", newJString(key))
  add(query_580004, "$.xgafv", newJString(Xgafv))
  add(query_580004, "prettyPrint", newJBool(prettyPrint))
  add(query_580004, "accessLevelFormat", newJString(accessLevelFormat))
  result = call_580002.call(path_580003, query_580004, nil, nil, nil)

var accesscontextmanagerAccessPoliciesAccessLevelsGet* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsGet_579971(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsGet",
    meth: HttpMethod.HttpGet, host: "accesscontextmanager.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsGet_579972,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsGet_579973,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_580024 = ref object of OpenApiRestCall_579408
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_580026(
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

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_580025(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update an Access Level. The longrunning
  ## operation from this RPC will have a successful status once the changes to
  ## the Access Level have propagated
  ## to long-lasting storage. Access Levels containing
  ## errors will result in an error response for the first error encountered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name for the Access Level. The `short_name` component
  ## must begin with a letter and only include alphanumeric and '_'. Format:
  ## `accessPolicies/{policy_id}/accessLevels/{short_name}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580027 = path.getOrDefault("name")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "name", valid_580027
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
  ##             : Required. Mask to control which fields get updated. Must be non-empty.
  section = newJObject()
  var valid_580028 = query.getOrDefault("upload_protocol")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "upload_protocol", valid_580028
  var valid_580029 = query.getOrDefault("fields")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "fields", valid_580029
  var valid_580030 = query.getOrDefault("quotaUser")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "quotaUser", valid_580030
  var valid_580031 = query.getOrDefault("alt")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = newJString("json"))
  if valid_580031 != nil:
    section.add "alt", valid_580031
  var valid_580032 = query.getOrDefault("oauth_token")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "oauth_token", valid_580032
  var valid_580033 = query.getOrDefault("callback")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "callback", valid_580033
  var valid_580034 = query.getOrDefault("access_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "access_token", valid_580034
  var valid_580035 = query.getOrDefault("uploadType")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "uploadType", valid_580035
  var valid_580036 = query.getOrDefault("key")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "key", valid_580036
  var valid_580037 = query.getOrDefault("$.xgafv")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = newJString("1"))
  if valid_580037 != nil:
    section.add "$.xgafv", valid_580037
  var valid_580038 = query.getOrDefault("prettyPrint")
  valid_580038 = validateParameter(valid_580038, JBool, required = false,
                                 default = newJBool(true))
  if valid_580038 != nil:
    section.add "prettyPrint", valid_580038
  var valid_580039 = query.getOrDefault("updateMask")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "updateMask", valid_580039
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

proc call*(call_580041: Call_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_580024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an Access Level. The longrunning
  ## operation from this RPC will have a successful status once the changes to
  ## the Access Level have propagated
  ## to long-lasting storage. Access Levels containing
  ## errors will result in an error response for the first error encountered.
  ## 
  let valid = call_580041.validator(path, query, header, formData, body)
  let scheme = call_580041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580041.url(scheme.get, call_580041.host, call_580041.base,
                         call_580041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580041, url, valid)

proc call*(call_580042: Call_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_580024;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## accesscontextmanagerAccessPoliciesAccessLevelsPatch
  ## Update an Access Level. The longrunning
  ## operation from this RPC will have a successful status once the changes to
  ## the Access Level have propagated
  ## to long-lasting storage. Access Levels containing
  ## errors will result in an error response for the first error encountered.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Resource name for the Access Level. The `short_name` component
  ## must begin with a letter and only include alphanumeric and '_'. Format:
  ## `accessPolicies/{policy_id}/accessLevels/{short_name}`
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
  ##             : Required. Mask to control which fields get updated. Must be non-empty.
  var path_580043 = newJObject()
  var query_580044 = newJObject()
  var body_580045 = newJObject()
  add(query_580044, "upload_protocol", newJString(uploadProtocol))
  add(query_580044, "fields", newJString(fields))
  add(query_580044, "quotaUser", newJString(quotaUser))
  add(path_580043, "name", newJString(name))
  add(query_580044, "alt", newJString(alt))
  add(query_580044, "oauth_token", newJString(oauthToken))
  add(query_580044, "callback", newJString(callback))
  add(query_580044, "access_token", newJString(accessToken))
  add(query_580044, "uploadType", newJString(uploadType))
  add(query_580044, "key", newJString(key))
  add(query_580044, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580045 = body
  add(query_580044, "prettyPrint", newJBool(prettyPrint))
  add(query_580044, "updateMask", newJString(updateMask))
  result = call_580042.call(path_580043, query_580044, nil, nil, body_580045)

var accesscontextmanagerAccessPoliciesAccessLevelsPatch* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_580024(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsPatch",
    meth: HttpMethod.HttpPatch, host: "accesscontextmanager.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_580025,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_580026,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_580005 = ref object of OpenApiRestCall_579408
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_580007(
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

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_580006(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Delete an Access Level by resource
  ## name. The longrunning operation from this RPC will have a successful status
  ## once the Access Level has been removed
  ## from long-lasting storage.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name for the Access Level.
  ## 
  ## Format:
  ## `accessPolicies/{policy_id}/accessLevels/{access_level_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580008 = path.getOrDefault("name")
  valid_580008 = validateParameter(valid_580008, JString, required = true,
                                 default = nil)
  if valid_580008 != nil:
    section.add "name", valid_580008
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
  var valid_580009 = query.getOrDefault("upload_protocol")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "upload_protocol", valid_580009
  var valid_580010 = query.getOrDefault("fields")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "fields", valid_580010
  var valid_580011 = query.getOrDefault("quotaUser")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "quotaUser", valid_580011
  var valid_580012 = query.getOrDefault("alt")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = newJString("json"))
  if valid_580012 != nil:
    section.add "alt", valid_580012
  var valid_580013 = query.getOrDefault("oauth_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "oauth_token", valid_580013
  var valid_580014 = query.getOrDefault("callback")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "callback", valid_580014
  var valid_580015 = query.getOrDefault("access_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "access_token", valid_580015
  var valid_580016 = query.getOrDefault("uploadType")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "uploadType", valid_580016
  var valid_580017 = query.getOrDefault("key")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "key", valid_580017
  var valid_580018 = query.getOrDefault("$.xgafv")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("1"))
  if valid_580018 != nil:
    section.add "$.xgafv", valid_580018
  var valid_580019 = query.getOrDefault("prettyPrint")
  valid_580019 = validateParameter(valid_580019, JBool, required = false,
                                 default = newJBool(true))
  if valid_580019 != nil:
    section.add "prettyPrint", valid_580019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580020: Call_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_580005;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an Access Level by resource
  ## name. The longrunning operation from this RPC will have a successful status
  ## once the Access Level has been removed
  ## from long-lasting storage.
  ## 
  let valid = call_580020.validator(path, query, header, formData, body)
  let scheme = call_580020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580020.url(scheme.get, call_580020.host, call_580020.base,
                         call_580020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580020, url, valid)

proc call*(call_580021: Call_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_580005;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## accesscontextmanagerAccessPoliciesAccessLevelsDelete
  ## Delete an Access Level by resource
  ## name. The longrunning operation from this RPC will have a successful status
  ## once the Access Level has been removed
  ## from long-lasting storage.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Resource name for the Access Level.
  ## 
  ## Format:
  ## `accessPolicies/{policy_id}/accessLevels/{access_level_id}`
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
  var path_580022 = newJObject()
  var query_580023 = newJObject()
  add(query_580023, "upload_protocol", newJString(uploadProtocol))
  add(query_580023, "fields", newJString(fields))
  add(query_580023, "quotaUser", newJString(quotaUser))
  add(path_580022, "name", newJString(name))
  add(query_580023, "alt", newJString(alt))
  add(query_580023, "oauth_token", newJString(oauthToken))
  add(query_580023, "callback", newJString(callback))
  add(query_580023, "access_token", newJString(accessToken))
  add(query_580023, "uploadType", newJString(uploadType))
  add(query_580023, "key", newJString(key))
  add(query_580023, "$.xgafv", newJString(Xgafv))
  add(query_580023, "prettyPrint", newJBool(prettyPrint))
  result = call_580021.call(path_580022, query_580023, nil, nil, nil)

var accesscontextmanagerAccessPoliciesAccessLevelsDelete* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_580005(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsDelete",
    meth: HttpMethod.HttpDelete, host: "accesscontextmanager.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_580006,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_580007,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerOperationsCancel_580046 = ref object of OpenApiRestCall_579408
proc url_AccesscontextmanagerOperationsCancel_580048(protocol: Scheme;
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

proc validate_AccesscontextmanagerOperationsCancel_580047(path: JsonNode;
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
  var valid_580049 = path.getOrDefault("name")
  valid_580049 = validateParameter(valid_580049, JString, required = true,
                                 default = nil)
  if valid_580049 != nil:
    section.add "name", valid_580049
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
  var valid_580050 = query.getOrDefault("upload_protocol")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "upload_protocol", valid_580050
  var valid_580051 = query.getOrDefault("fields")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "fields", valid_580051
  var valid_580052 = query.getOrDefault("quotaUser")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "quotaUser", valid_580052
  var valid_580053 = query.getOrDefault("alt")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("json"))
  if valid_580053 != nil:
    section.add "alt", valid_580053
  var valid_580054 = query.getOrDefault("oauth_token")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "oauth_token", valid_580054
  var valid_580055 = query.getOrDefault("callback")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "callback", valid_580055
  var valid_580056 = query.getOrDefault("access_token")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "access_token", valid_580056
  var valid_580057 = query.getOrDefault("uploadType")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "uploadType", valid_580057
  var valid_580058 = query.getOrDefault("key")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "key", valid_580058
  var valid_580059 = query.getOrDefault("$.xgafv")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = newJString("1"))
  if valid_580059 != nil:
    section.add "$.xgafv", valid_580059
  var valid_580060 = query.getOrDefault("prettyPrint")
  valid_580060 = validateParameter(valid_580060, JBool, required = false,
                                 default = newJBool(true))
  if valid_580060 != nil:
    section.add "prettyPrint", valid_580060
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

proc call*(call_580062: Call_AccesscontextmanagerOperationsCancel_580046;
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
  let valid = call_580062.validator(path, query, header, formData, body)
  let scheme = call_580062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580062.url(scheme.get, call_580062.host, call_580062.base,
                         call_580062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580062, url, valid)

proc call*(call_580063: Call_AccesscontextmanagerOperationsCancel_580046;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## accesscontextmanagerOperationsCancel
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580064 = newJObject()
  var query_580065 = newJObject()
  var body_580066 = newJObject()
  add(query_580065, "upload_protocol", newJString(uploadProtocol))
  add(query_580065, "fields", newJString(fields))
  add(query_580065, "quotaUser", newJString(quotaUser))
  add(path_580064, "name", newJString(name))
  add(query_580065, "alt", newJString(alt))
  add(query_580065, "oauth_token", newJString(oauthToken))
  add(query_580065, "callback", newJString(callback))
  add(query_580065, "access_token", newJString(accessToken))
  add(query_580065, "uploadType", newJString(uploadType))
  add(query_580065, "key", newJString(key))
  add(query_580065, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580066 = body
  add(query_580065, "prettyPrint", newJBool(prettyPrint))
  result = call_580063.call(path_580064, query_580065, nil, nil, body_580066)

var accesscontextmanagerOperationsCancel* = Call_AccesscontextmanagerOperationsCancel_580046(
    name: "accesscontextmanagerOperationsCancel", meth: HttpMethod.HttpPost,
    host: "accesscontextmanager.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_AccesscontextmanagerOperationsCancel_580047, base: "/",
    url: url_AccesscontextmanagerOperationsCancel_580048, schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_580089 = ref object of OpenApiRestCall_579408
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_580091(
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
               (kind: ConstantSegment, value: "/accessLevels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_580090(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create an Access Level. The longrunning
  ## operation from this RPC will have a successful status once the Access
  ## Level has
  ## propagated to long-lasting storage. Access Levels containing
  ## errors will result in an error response for the first error encountered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Resource name for the access policy which owns this Access
  ## Level.
  ## 
  ## Format: `accessPolicies/{policy_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580092 = path.getOrDefault("parent")
  valid_580092 = validateParameter(valid_580092, JString, required = true,
                                 default = nil)
  if valid_580092 != nil:
    section.add "parent", valid_580092
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
  var valid_580093 = query.getOrDefault("upload_protocol")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "upload_protocol", valid_580093
  var valid_580094 = query.getOrDefault("fields")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "fields", valid_580094
  var valid_580095 = query.getOrDefault("quotaUser")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "quotaUser", valid_580095
  var valid_580096 = query.getOrDefault("alt")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = newJString("json"))
  if valid_580096 != nil:
    section.add "alt", valid_580096
  var valid_580097 = query.getOrDefault("oauth_token")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "oauth_token", valid_580097
  var valid_580098 = query.getOrDefault("callback")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "callback", valid_580098
  var valid_580099 = query.getOrDefault("access_token")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "access_token", valid_580099
  var valid_580100 = query.getOrDefault("uploadType")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "uploadType", valid_580100
  var valid_580101 = query.getOrDefault("key")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "key", valid_580101
  var valid_580102 = query.getOrDefault("$.xgafv")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = newJString("1"))
  if valid_580102 != nil:
    section.add "$.xgafv", valid_580102
  var valid_580103 = query.getOrDefault("prettyPrint")
  valid_580103 = validateParameter(valid_580103, JBool, required = false,
                                 default = newJBool(true))
  if valid_580103 != nil:
    section.add "prettyPrint", valid_580103
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

proc call*(call_580105: Call_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_580089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an Access Level. The longrunning
  ## operation from this RPC will have a successful status once the Access
  ## Level has
  ## propagated to long-lasting storage. Access Levels containing
  ## errors will result in an error response for the first error encountered.
  ## 
  let valid = call_580105.validator(path, query, header, formData, body)
  let scheme = call_580105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580105.url(scheme.get, call_580105.host, call_580105.base,
                         call_580105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580105, url, valid)

proc call*(call_580106: Call_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_580089;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## accesscontextmanagerAccessPoliciesAccessLevelsCreate
  ## Create an Access Level. The longrunning
  ## operation from this RPC will have a successful status once the Access
  ## Level has
  ## propagated to long-lasting storage. Access Levels containing
  ## errors will result in an error response for the first error encountered.
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
  ##         : Required. Resource name for the access policy which owns this Access
  ## Level.
  ## 
  ## Format: `accessPolicies/{policy_id}`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580107 = newJObject()
  var query_580108 = newJObject()
  var body_580109 = newJObject()
  add(query_580108, "upload_protocol", newJString(uploadProtocol))
  add(query_580108, "fields", newJString(fields))
  add(query_580108, "quotaUser", newJString(quotaUser))
  add(query_580108, "alt", newJString(alt))
  add(query_580108, "oauth_token", newJString(oauthToken))
  add(query_580108, "callback", newJString(callback))
  add(query_580108, "access_token", newJString(accessToken))
  add(query_580108, "uploadType", newJString(uploadType))
  add(path_580107, "parent", newJString(parent))
  add(query_580108, "key", newJString(key))
  add(query_580108, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580109 = body
  add(query_580108, "prettyPrint", newJBool(prettyPrint))
  result = call_580106.call(path_580107, query_580108, nil, nil, body_580109)

var accesscontextmanagerAccessPoliciesAccessLevelsCreate* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_580089(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsCreate",
    meth: HttpMethod.HttpPost, host: "accesscontextmanager.googleapis.com",
    route: "/v1/{parent}/accessLevels",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_580090,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_580091,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsList_580067 = ref object of OpenApiRestCall_579408
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsList_580069(
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
               (kind: ConstantSegment, value: "/accessLevels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsList_580068(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all Access Levels for an access
  ## policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Resource name for the access policy to list Access Levels from.
  ## 
  ## Format:
  ## `accessPolicies/{policy_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580070 = path.getOrDefault("parent")
  valid_580070 = validateParameter(valid_580070, JString, required = true,
                                 default = nil)
  if valid_580070 != nil:
    section.add "parent", valid_580070
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Next page token for the next batch of Access Level instances.
  ## Defaults to the first page of results.
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
  ##           : Number of Access Levels to include in
  ## the list. Default 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   accessLevelFormat: JString
  ##                    : Whether to return `BasicLevels` in the Cloud Common Expression language, as
  ## `CustomLevels`, rather than as `BasicLevels`. Defaults to returning
  ## `AccessLevels` in the format they were defined.
  section = newJObject()
  var valid_580071 = query.getOrDefault("upload_protocol")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "upload_protocol", valid_580071
  var valid_580072 = query.getOrDefault("fields")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "fields", valid_580072
  var valid_580073 = query.getOrDefault("pageToken")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "pageToken", valid_580073
  var valid_580074 = query.getOrDefault("quotaUser")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "quotaUser", valid_580074
  var valid_580075 = query.getOrDefault("alt")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = newJString("json"))
  if valid_580075 != nil:
    section.add "alt", valid_580075
  var valid_580076 = query.getOrDefault("oauth_token")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "oauth_token", valid_580076
  var valid_580077 = query.getOrDefault("callback")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "callback", valid_580077
  var valid_580078 = query.getOrDefault("access_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "access_token", valid_580078
  var valid_580079 = query.getOrDefault("uploadType")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "uploadType", valid_580079
  var valid_580080 = query.getOrDefault("key")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "key", valid_580080
  var valid_580081 = query.getOrDefault("$.xgafv")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = newJString("1"))
  if valid_580081 != nil:
    section.add "$.xgafv", valid_580081
  var valid_580082 = query.getOrDefault("pageSize")
  valid_580082 = validateParameter(valid_580082, JInt, required = false, default = nil)
  if valid_580082 != nil:
    section.add "pageSize", valid_580082
  var valid_580083 = query.getOrDefault("prettyPrint")
  valid_580083 = validateParameter(valid_580083, JBool, required = false,
                                 default = newJBool(true))
  if valid_580083 != nil:
    section.add "prettyPrint", valid_580083
  var valid_580084 = query.getOrDefault("accessLevelFormat")
  valid_580084 = validateParameter(valid_580084, JString, required = false, default = newJString(
      "LEVEL_FORMAT_UNSPECIFIED"))
  if valid_580084 != nil:
    section.add "accessLevelFormat", valid_580084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580085: Call_AccesscontextmanagerAccessPoliciesAccessLevelsList_580067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all Access Levels for an access
  ## policy.
  ## 
  let valid = call_580085.validator(path, query, header, formData, body)
  let scheme = call_580085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580085.url(scheme.get, call_580085.host, call_580085.base,
                         call_580085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580085, url, valid)

proc call*(call_580086: Call_AccesscontextmanagerAccessPoliciesAccessLevelsList_580067;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true;
          accessLevelFormat: string = "LEVEL_FORMAT_UNSPECIFIED"): Recallable =
  ## accesscontextmanagerAccessPoliciesAccessLevelsList
  ## List all Access Levels for an access
  ## policy.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Next page token for the next batch of Access Level instances.
  ## Defaults to the first page of results.
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
  ##         : Required. Resource name for the access policy to list Access Levels from.
  ## 
  ## Format:
  ## `accessPolicies/{policy_id}`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of Access Levels to include in
  ## the list. Default 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   accessLevelFormat: string
  ##                    : Whether to return `BasicLevels` in the Cloud Common Expression language, as
  ## `CustomLevels`, rather than as `BasicLevels`. Defaults to returning
  ## `AccessLevels` in the format they were defined.
  var path_580087 = newJObject()
  var query_580088 = newJObject()
  add(query_580088, "upload_protocol", newJString(uploadProtocol))
  add(query_580088, "fields", newJString(fields))
  add(query_580088, "pageToken", newJString(pageToken))
  add(query_580088, "quotaUser", newJString(quotaUser))
  add(query_580088, "alt", newJString(alt))
  add(query_580088, "oauth_token", newJString(oauthToken))
  add(query_580088, "callback", newJString(callback))
  add(query_580088, "access_token", newJString(accessToken))
  add(query_580088, "uploadType", newJString(uploadType))
  add(path_580087, "parent", newJString(parent))
  add(query_580088, "key", newJString(key))
  add(query_580088, "$.xgafv", newJString(Xgafv))
  add(query_580088, "pageSize", newJInt(pageSize))
  add(query_580088, "prettyPrint", newJBool(prettyPrint))
  add(query_580088, "accessLevelFormat", newJString(accessLevelFormat))
  result = call_580086.call(path_580087, query_580088, nil, nil, nil)

var accesscontextmanagerAccessPoliciesAccessLevelsList* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsList_580067(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsList",
    meth: HttpMethod.HttpGet, host: "accesscontextmanager.googleapis.com",
    route: "/v1/{parent}/accessLevels",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsList_580068,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsList_580069,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_580131 = ref object of OpenApiRestCall_579408
proc url_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_580133(
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
               (kind: ConstantSegment, value: "/servicePerimeters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_580132(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create an Service Perimeter. The
  ## longrunning operation from this RPC will have a successful status once the
  ## Service Perimeter has
  ## propagated to long-lasting storage. Service Perimeters containing
  ## errors will result in an error response for the first error encountered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Resource name for the access policy which owns this Service
  ## Perimeter.
  ## 
  ## Format: `accessPolicies/{policy_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580134 = path.getOrDefault("parent")
  valid_580134 = validateParameter(valid_580134, JString, required = true,
                                 default = nil)
  if valid_580134 != nil:
    section.add "parent", valid_580134
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
  var valid_580135 = query.getOrDefault("upload_protocol")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "upload_protocol", valid_580135
  var valid_580136 = query.getOrDefault("fields")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "fields", valid_580136
  var valid_580137 = query.getOrDefault("quotaUser")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "quotaUser", valid_580137
  var valid_580138 = query.getOrDefault("alt")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = newJString("json"))
  if valid_580138 != nil:
    section.add "alt", valid_580138
  var valid_580139 = query.getOrDefault("oauth_token")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "oauth_token", valid_580139
  var valid_580140 = query.getOrDefault("callback")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "callback", valid_580140
  var valid_580141 = query.getOrDefault("access_token")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "access_token", valid_580141
  var valid_580142 = query.getOrDefault("uploadType")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "uploadType", valid_580142
  var valid_580143 = query.getOrDefault("key")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "key", valid_580143
  var valid_580144 = query.getOrDefault("$.xgafv")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = newJString("1"))
  if valid_580144 != nil:
    section.add "$.xgafv", valid_580144
  var valid_580145 = query.getOrDefault("prettyPrint")
  valid_580145 = validateParameter(valid_580145, JBool, required = false,
                                 default = newJBool(true))
  if valid_580145 != nil:
    section.add "prettyPrint", valid_580145
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

proc call*(call_580147: Call_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_580131;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an Service Perimeter. The
  ## longrunning operation from this RPC will have a successful status once the
  ## Service Perimeter has
  ## propagated to long-lasting storage. Service Perimeters containing
  ## errors will result in an error response for the first error encountered.
  ## 
  let valid = call_580147.validator(path, query, header, formData, body)
  let scheme = call_580147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580147.url(scheme.get, call_580147.host, call_580147.base,
                         call_580147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580147, url, valid)

proc call*(call_580148: Call_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_580131;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## accesscontextmanagerAccessPoliciesServicePerimetersCreate
  ## Create an Service Perimeter. The
  ## longrunning operation from this RPC will have a successful status once the
  ## Service Perimeter has
  ## propagated to long-lasting storage. Service Perimeters containing
  ## errors will result in an error response for the first error encountered.
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
  ##         : Required. Resource name for the access policy which owns this Service
  ## Perimeter.
  ## 
  ## Format: `accessPolicies/{policy_id}`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580149 = newJObject()
  var query_580150 = newJObject()
  var body_580151 = newJObject()
  add(query_580150, "upload_protocol", newJString(uploadProtocol))
  add(query_580150, "fields", newJString(fields))
  add(query_580150, "quotaUser", newJString(quotaUser))
  add(query_580150, "alt", newJString(alt))
  add(query_580150, "oauth_token", newJString(oauthToken))
  add(query_580150, "callback", newJString(callback))
  add(query_580150, "access_token", newJString(accessToken))
  add(query_580150, "uploadType", newJString(uploadType))
  add(path_580149, "parent", newJString(parent))
  add(query_580150, "key", newJString(key))
  add(query_580150, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580151 = body
  add(query_580150, "prettyPrint", newJBool(prettyPrint))
  result = call_580148.call(path_580149, query_580150, nil, nil, body_580151)

var accesscontextmanagerAccessPoliciesServicePerimetersCreate* = Call_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_580131(
    name: "accesscontextmanagerAccessPoliciesServicePerimetersCreate",
    meth: HttpMethod.HttpPost, host: "accesscontextmanager.googleapis.com",
    route: "/v1/{parent}/servicePerimeters", validator: validate_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_580132,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_580133,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesServicePerimetersList_580110 = ref object of OpenApiRestCall_579408
proc url_AccesscontextmanagerAccessPoliciesServicePerimetersList_580112(
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
               (kind: ConstantSegment, value: "/servicePerimeters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesServicePerimetersList_580111(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all Service Perimeters for an
  ## access policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Resource name for the access policy to list Service Perimeters from.
  ## 
  ## Format:
  ## `accessPolicies/{policy_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580113 = path.getOrDefault("parent")
  valid_580113 = validateParameter(valid_580113, JString, required = true,
                                 default = nil)
  if valid_580113 != nil:
    section.add "parent", valid_580113
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Next page token for the next batch of Service Perimeter instances.
  ## Defaults to the first page of results.
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
  ##           : Number of Service Perimeters to include
  ## in the list. Default 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580114 = query.getOrDefault("upload_protocol")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "upload_protocol", valid_580114
  var valid_580115 = query.getOrDefault("fields")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "fields", valid_580115
  var valid_580116 = query.getOrDefault("pageToken")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "pageToken", valid_580116
  var valid_580117 = query.getOrDefault("quotaUser")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "quotaUser", valid_580117
  var valid_580118 = query.getOrDefault("alt")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = newJString("json"))
  if valid_580118 != nil:
    section.add "alt", valid_580118
  var valid_580119 = query.getOrDefault("oauth_token")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "oauth_token", valid_580119
  var valid_580120 = query.getOrDefault("callback")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "callback", valid_580120
  var valid_580121 = query.getOrDefault("access_token")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "access_token", valid_580121
  var valid_580122 = query.getOrDefault("uploadType")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "uploadType", valid_580122
  var valid_580123 = query.getOrDefault("key")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "key", valid_580123
  var valid_580124 = query.getOrDefault("$.xgafv")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = newJString("1"))
  if valid_580124 != nil:
    section.add "$.xgafv", valid_580124
  var valid_580125 = query.getOrDefault("pageSize")
  valid_580125 = validateParameter(valid_580125, JInt, required = false, default = nil)
  if valid_580125 != nil:
    section.add "pageSize", valid_580125
  var valid_580126 = query.getOrDefault("prettyPrint")
  valid_580126 = validateParameter(valid_580126, JBool, required = false,
                                 default = newJBool(true))
  if valid_580126 != nil:
    section.add "prettyPrint", valid_580126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580127: Call_AccesscontextmanagerAccessPoliciesServicePerimetersList_580110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all Service Perimeters for an
  ## access policy.
  ## 
  let valid = call_580127.validator(path, query, header, formData, body)
  let scheme = call_580127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580127.url(scheme.get, call_580127.host, call_580127.base,
                         call_580127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580127, url, valid)

proc call*(call_580128: Call_AccesscontextmanagerAccessPoliciesServicePerimetersList_580110;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## accesscontextmanagerAccessPoliciesServicePerimetersList
  ## List all Service Perimeters for an
  ## access policy.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Next page token for the next batch of Service Perimeter instances.
  ## Defaults to the first page of results.
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
  ##         : Required. Resource name for the access policy to list Service Perimeters from.
  ## 
  ## Format:
  ## `accessPolicies/{policy_id}`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of Service Perimeters to include
  ## in the list. Default 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580129 = newJObject()
  var query_580130 = newJObject()
  add(query_580130, "upload_protocol", newJString(uploadProtocol))
  add(query_580130, "fields", newJString(fields))
  add(query_580130, "pageToken", newJString(pageToken))
  add(query_580130, "quotaUser", newJString(quotaUser))
  add(query_580130, "alt", newJString(alt))
  add(query_580130, "oauth_token", newJString(oauthToken))
  add(query_580130, "callback", newJString(callback))
  add(query_580130, "access_token", newJString(accessToken))
  add(query_580130, "uploadType", newJString(uploadType))
  add(path_580129, "parent", newJString(parent))
  add(query_580130, "key", newJString(key))
  add(query_580130, "$.xgafv", newJString(Xgafv))
  add(query_580130, "pageSize", newJInt(pageSize))
  add(query_580130, "prettyPrint", newJBool(prettyPrint))
  result = call_580128.call(path_580129, query_580130, nil, nil, nil)

var accesscontextmanagerAccessPoliciesServicePerimetersList* = Call_AccesscontextmanagerAccessPoliciesServicePerimetersList_580110(
    name: "accesscontextmanagerAccessPoliciesServicePerimetersList",
    meth: HttpMethod.HttpGet, host: "accesscontextmanager.googleapis.com",
    route: "/v1/{parent}/servicePerimeters", validator: validate_AccesscontextmanagerAccessPoliciesServicePerimetersList_580111,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesServicePerimetersList_580112,
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
