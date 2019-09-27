
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "accesscontextmanager"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AccesscontextmanagerAccessPoliciesCreate_597952 = ref object of OpenApiRestCall_597408
proc url_AccesscontextmanagerAccessPoliciesCreate_597954(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AccesscontextmanagerAccessPoliciesCreate_597953(path: JsonNode;
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
  var valid_597955 = query.getOrDefault("upload_protocol")
  valid_597955 = validateParameter(valid_597955, JString, required = false,
                                 default = nil)
  if valid_597955 != nil:
    section.add "upload_protocol", valid_597955
  var valid_597956 = query.getOrDefault("fields")
  valid_597956 = validateParameter(valid_597956, JString, required = false,
                                 default = nil)
  if valid_597956 != nil:
    section.add "fields", valid_597956
  var valid_597957 = query.getOrDefault("quotaUser")
  valid_597957 = validateParameter(valid_597957, JString, required = false,
                                 default = nil)
  if valid_597957 != nil:
    section.add "quotaUser", valid_597957
  var valid_597958 = query.getOrDefault("alt")
  valid_597958 = validateParameter(valid_597958, JString, required = false,
                                 default = newJString("json"))
  if valid_597958 != nil:
    section.add "alt", valid_597958
  var valid_597959 = query.getOrDefault("oauth_token")
  valid_597959 = validateParameter(valid_597959, JString, required = false,
                                 default = nil)
  if valid_597959 != nil:
    section.add "oauth_token", valid_597959
  var valid_597960 = query.getOrDefault("callback")
  valid_597960 = validateParameter(valid_597960, JString, required = false,
                                 default = nil)
  if valid_597960 != nil:
    section.add "callback", valid_597960
  var valid_597961 = query.getOrDefault("access_token")
  valid_597961 = validateParameter(valid_597961, JString, required = false,
                                 default = nil)
  if valid_597961 != nil:
    section.add "access_token", valid_597961
  var valid_597962 = query.getOrDefault("uploadType")
  valid_597962 = validateParameter(valid_597962, JString, required = false,
                                 default = nil)
  if valid_597962 != nil:
    section.add "uploadType", valid_597962
  var valid_597963 = query.getOrDefault("key")
  valid_597963 = validateParameter(valid_597963, JString, required = false,
                                 default = nil)
  if valid_597963 != nil:
    section.add "key", valid_597963
  var valid_597964 = query.getOrDefault("$.xgafv")
  valid_597964 = validateParameter(valid_597964, JString, required = false,
                                 default = newJString("1"))
  if valid_597964 != nil:
    section.add "$.xgafv", valid_597964
  var valid_597965 = query.getOrDefault("prettyPrint")
  valid_597965 = validateParameter(valid_597965, JBool, required = false,
                                 default = newJBool(true))
  if valid_597965 != nil:
    section.add "prettyPrint", valid_597965
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

proc call*(call_597967: Call_AccesscontextmanagerAccessPoliciesCreate_597952;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an `AccessPolicy`. Fails if this organization already has a
  ## `AccessPolicy`. The longrunning Operation will have a successful status
  ## once the `AccessPolicy` has propagated to long-lasting storage.
  ## Syntactic and basic semantic errors will be returned in `metadata` as a
  ## BadRequest proto.
  ## 
  let valid = call_597967.validator(path, query, header, formData, body)
  let scheme = call_597967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597967.url(scheme.get, call_597967.host, call_597967.base,
                         call_597967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597967, url, valid)

proc call*(call_597968: Call_AccesscontextmanagerAccessPoliciesCreate_597952;
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
  var query_597969 = newJObject()
  var body_597970 = newJObject()
  add(query_597969, "upload_protocol", newJString(uploadProtocol))
  add(query_597969, "fields", newJString(fields))
  add(query_597969, "quotaUser", newJString(quotaUser))
  add(query_597969, "alt", newJString(alt))
  add(query_597969, "oauth_token", newJString(oauthToken))
  add(query_597969, "callback", newJString(callback))
  add(query_597969, "access_token", newJString(accessToken))
  add(query_597969, "uploadType", newJString(uploadType))
  add(query_597969, "key", newJString(key))
  add(query_597969, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597970 = body
  add(query_597969, "prettyPrint", newJBool(prettyPrint))
  result = call_597968.call(nil, query_597969, nil, nil, body_597970)

var accesscontextmanagerAccessPoliciesCreate* = Call_AccesscontextmanagerAccessPoliciesCreate_597952(
    name: "accesscontextmanagerAccessPoliciesCreate", meth: HttpMethod.HttpPost,
    host: "accesscontextmanager.googleapis.com", route: "/v1/accessPolicies",
    validator: validate_AccesscontextmanagerAccessPoliciesCreate_597953,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesCreate_597954,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesList_597677 = ref object of OpenApiRestCall_597408
proc url_AccesscontextmanagerAccessPoliciesList_597679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AccesscontextmanagerAccessPoliciesList_597678(path: JsonNode;
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
  var valid_597813 = query.getOrDefault("parent")
  valid_597813 = validateParameter(valid_597813, JString, required = false,
                                 default = nil)
  if valid_597813 != nil:
    section.add "parent", valid_597813
  var valid_597814 = query.getOrDefault("key")
  valid_597814 = validateParameter(valid_597814, JString, required = false,
                                 default = nil)
  if valid_597814 != nil:
    section.add "key", valid_597814
  var valid_597815 = query.getOrDefault("$.xgafv")
  valid_597815 = validateParameter(valid_597815, JString, required = false,
                                 default = newJString("1"))
  if valid_597815 != nil:
    section.add "$.xgafv", valid_597815
  var valid_597816 = query.getOrDefault("pageSize")
  valid_597816 = validateParameter(valid_597816, JInt, required = false, default = nil)
  if valid_597816 != nil:
    section.add "pageSize", valid_597816
  var valid_597817 = query.getOrDefault("prettyPrint")
  valid_597817 = validateParameter(valid_597817, JBool, required = false,
                                 default = newJBool(true))
  if valid_597817 != nil:
    section.add "prettyPrint", valid_597817
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597840: Call_AccesscontextmanagerAccessPoliciesList_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all AccessPolicies under a
  ## container.
  ## 
  let valid = call_597840.validator(path, query, header, formData, body)
  let scheme = call_597840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597840.url(scheme.get, call_597840.host, call_597840.base,
                         call_597840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597840, url, valid)

proc call*(call_597911: Call_AccesscontextmanagerAccessPoliciesList_597677;
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
  var query_597912 = newJObject()
  add(query_597912, "upload_protocol", newJString(uploadProtocol))
  add(query_597912, "fields", newJString(fields))
  add(query_597912, "pageToken", newJString(pageToken))
  add(query_597912, "quotaUser", newJString(quotaUser))
  add(query_597912, "alt", newJString(alt))
  add(query_597912, "oauth_token", newJString(oauthToken))
  add(query_597912, "callback", newJString(callback))
  add(query_597912, "access_token", newJString(accessToken))
  add(query_597912, "uploadType", newJString(uploadType))
  add(query_597912, "parent", newJString(parent))
  add(query_597912, "key", newJString(key))
  add(query_597912, "$.xgafv", newJString(Xgafv))
  add(query_597912, "pageSize", newJInt(pageSize))
  add(query_597912, "prettyPrint", newJBool(prettyPrint))
  result = call_597911.call(nil, query_597912, nil, nil, nil)

var accesscontextmanagerAccessPoliciesList* = Call_AccesscontextmanagerAccessPoliciesList_597677(
    name: "accesscontextmanagerAccessPoliciesList", meth: HttpMethod.HttpGet,
    host: "accesscontextmanager.googleapis.com", route: "/v1/accessPolicies",
    validator: validate_AccesscontextmanagerAccessPoliciesList_597678, base: "/",
    url: url_AccesscontextmanagerAccessPoliciesList_597679,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsGet_597971 = ref object of OpenApiRestCall_597408
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsGet_597973(
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

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsGet_597972(
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
  var valid_597988 = path.getOrDefault("name")
  valid_597988 = validateParameter(valid_597988, JString, required = true,
                                 default = nil)
  if valid_597988 != nil:
    section.add "name", valid_597988
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
  var valid_597989 = query.getOrDefault("upload_protocol")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "upload_protocol", valid_597989
  var valid_597990 = query.getOrDefault("fields")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "fields", valid_597990
  var valid_597991 = query.getOrDefault("quotaUser")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "quotaUser", valid_597991
  var valid_597992 = query.getOrDefault("alt")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = newJString("json"))
  if valid_597992 != nil:
    section.add "alt", valid_597992
  var valid_597993 = query.getOrDefault("oauth_token")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "oauth_token", valid_597993
  var valid_597994 = query.getOrDefault("callback")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "callback", valid_597994
  var valid_597995 = query.getOrDefault("access_token")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "access_token", valid_597995
  var valid_597996 = query.getOrDefault("uploadType")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "uploadType", valid_597996
  var valid_597997 = query.getOrDefault("key")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "key", valid_597997
  var valid_597998 = query.getOrDefault("$.xgafv")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = newJString("1"))
  if valid_597998 != nil:
    section.add "$.xgafv", valid_597998
  var valid_597999 = query.getOrDefault("prettyPrint")
  valid_597999 = validateParameter(valid_597999, JBool, required = false,
                                 default = newJBool(true))
  if valid_597999 != nil:
    section.add "prettyPrint", valid_597999
  var valid_598000 = query.getOrDefault("accessLevelFormat")
  valid_598000 = validateParameter(valid_598000, JString, required = false, default = newJString(
      "LEVEL_FORMAT_UNSPECIFIED"))
  if valid_598000 != nil:
    section.add "accessLevelFormat", valid_598000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598001: Call_AccesscontextmanagerAccessPoliciesAccessLevelsGet_597971;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an Access Level by resource
  ## name.
  ## 
  let valid = call_598001.validator(path, query, header, formData, body)
  let scheme = call_598001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598001.url(scheme.get, call_598001.host, call_598001.base,
                         call_598001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598001, url, valid)

proc call*(call_598002: Call_AccesscontextmanagerAccessPoliciesAccessLevelsGet_597971;
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
  var path_598003 = newJObject()
  var query_598004 = newJObject()
  add(query_598004, "upload_protocol", newJString(uploadProtocol))
  add(query_598004, "fields", newJString(fields))
  add(query_598004, "quotaUser", newJString(quotaUser))
  add(path_598003, "name", newJString(name))
  add(query_598004, "alt", newJString(alt))
  add(query_598004, "oauth_token", newJString(oauthToken))
  add(query_598004, "callback", newJString(callback))
  add(query_598004, "access_token", newJString(accessToken))
  add(query_598004, "uploadType", newJString(uploadType))
  add(query_598004, "key", newJString(key))
  add(query_598004, "$.xgafv", newJString(Xgafv))
  add(query_598004, "prettyPrint", newJBool(prettyPrint))
  add(query_598004, "accessLevelFormat", newJString(accessLevelFormat))
  result = call_598002.call(path_598003, query_598004, nil, nil, nil)

var accesscontextmanagerAccessPoliciesAccessLevelsGet* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsGet_597971(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsGet",
    meth: HttpMethod.HttpGet, host: "accesscontextmanager.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsGet_597972,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsGet_597973,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_598024 = ref object of OpenApiRestCall_597408
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_598026(
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

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_598025(
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
  var valid_598027 = path.getOrDefault("name")
  valid_598027 = validateParameter(valid_598027, JString, required = true,
                                 default = nil)
  if valid_598027 != nil:
    section.add "name", valid_598027
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
  var valid_598028 = query.getOrDefault("upload_protocol")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = nil)
  if valid_598028 != nil:
    section.add "upload_protocol", valid_598028
  var valid_598029 = query.getOrDefault("fields")
  valid_598029 = validateParameter(valid_598029, JString, required = false,
                                 default = nil)
  if valid_598029 != nil:
    section.add "fields", valid_598029
  var valid_598030 = query.getOrDefault("quotaUser")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "quotaUser", valid_598030
  var valid_598031 = query.getOrDefault("alt")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = newJString("json"))
  if valid_598031 != nil:
    section.add "alt", valid_598031
  var valid_598032 = query.getOrDefault("oauth_token")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "oauth_token", valid_598032
  var valid_598033 = query.getOrDefault("callback")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "callback", valid_598033
  var valid_598034 = query.getOrDefault("access_token")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "access_token", valid_598034
  var valid_598035 = query.getOrDefault("uploadType")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "uploadType", valid_598035
  var valid_598036 = query.getOrDefault("key")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "key", valid_598036
  var valid_598037 = query.getOrDefault("$.xgafv")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = newJString("1"))
  if valid_598037 != nil:
    section.add "$.xgafv", valid_598037
  var valid_598038 = query.getOrDefault("prettyPrint")
  valid_598038 = validateParameter(valid_598038, JBool, required = false,
                                 default = newJBool(true))
  if valid_598038 != nil:
    section.add "prettyPrint", valid_598038
  var valid_598039 = query.getOrDefault("updateMask")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "updateMask", valid_598039
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

proc call*(call_598041: Call_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_598024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an Access Level. The longrunning
  ## operation from this RPC will have a successful status once the changes to
  ## the Access Level have propagated
  ## to long-lasting storage. Access Levels containing
  ## errors will result in an error response for the first error encountered.
  ## 
  let valid = call_598041.validator(path, query, header, formData, body)
  let scheme = call_598041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598041.url(scheme.get, call_598041.host, call_598041.base,
                         call_598041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598041, url, valid)

proc call*(call_598042: Call_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_598024;
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
  var path_598043 = newJObject()
  var query_598044 = newJObject()
  var body_598045 = newJObject()
  add(query_598044, "upload_protocol", newJString(uploadProtocol))
  add(query_598044, "fields", newJString(fields))
  add(query_598044, "quotaUser", newJString(quotaUser))
  add(path_598043, "name", newJString(name))
  add(query_598044, "alt", newJString(alt))
  add(query_598044, "oauth_token", newJString(oauthToken))
  add(query_598044, "callback", newJString(callback))
  add(query_598044, "access_token", newJString(accessToken))
  add(query_598044, "uploadType", newJString(uploadType))
  add(query_598044, "key", newJString(key))
  add(query_598044, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598045 = body
  add(query_598044, "prettyPrint", newJBool(prettyPrint))
  add(query_598044, "updateMask", newJString(updateMask))
  result = call_598042.call(path_598043, query_598044, nil, nil, body_598045)

var accesscontextmanagerAccessPoliciesAccessLevelsPatch* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_598024(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsPatch",
    meth: HttpMethod.HttpPatch, host: "accesscontextmanager.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_598025,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_598026,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_598005 = ref object of OpenApiRestCall_597408
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_598007(
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

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_598006(
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
  var valid_598008 = path.getOrDefault("name")
  valid_598008 = validateParameter(valid_598008, JString, required = true,
                                 default = nil)
  if valid_598008 != nil:
    section.add "name", valid_598008
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
  var valid_598009 = query.getOrDefault("upload_protocol")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "upload_protocol", valid_598009
  var valid_598010 = query.getOrDefault("fields")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "fields", valid_598010
  var valid_598011 = query.getOrDefault("quotaUser")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "quotaUser", valid_598011
  var valid_598012 = query.getOrDefault("alt")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = newJString("json"))
  if valid_598012 != nil:
    section.add "alt", valid_598012
  var valid_598013 = query.getOrDefault("oauth_token")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "oauth_token", valid_598013
  var valid_598014 = query.getOrDefault("callback")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "callback", valid_598014
  var valid_598015 = query.getOrDefault("access_token")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "access_token", valid_598015
  var valid_598016 = query.getOrDefault("uploadType")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "uploadType", valid_598016
  var valid_598017 = query.getOrDefault("key")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "key", valid_598017
  var valid_598018 = query.getOrDefault("$.xgafv")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = newJString("1"))
  if valid_598018 != nil:
    section.add "$.xgafv", valid_598018
  var valid_598019 = query.getOrDefault("prettyPrint")
  valid_598019 = validateParameter(valid_598019, JBool, required = false,
                                 default = newJBool(true))
  if valid_598019 != nil:
    section.add "prettyPrint", valid_598019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598020: Call_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_598005;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an Access Level by resource
  ## name. The longrunning operation from this RPC will have a successful status
  ## once the Access Level has been removed
  ## from long-lasting storage.
  ## 
  let valid = call_598020.validator(path, query, header, formData, body)
  let scheme = call_598020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598020.url(scheme.get, call_598020.host, call_598020.base,
                         call_598020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598020, url, valid)

proc call*(call_598021: Call_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_598005;
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
  var path_598022 = newJObject()
  var query_598023 = newJObject()
  add(query_598023, "upload_protocol", newJString(uploadProtocol))
  add(query_598023, "fields", newJString(fields))
  add(query_598023, "quotaUser", newJString(quotaUser))
  add(path_598022, "name", newJString(name))
  add(query_598023, "alt", newJString(alt))
  add(query_598023, "oauth_token", newJString(oauthToken))
  add(query_598023, "callback", newJString(callback))
  add(query_598023, "access_token", newJString(accessToken))
  add(query_598023, "uploadType", newJString(uploadType))
  add(query_598023, "key", newJString(key))
  add(query_598023, "$.xgafv", newJString(Xgafv))
  add(query_598023, "prettyPrint", newJBool(prettyPrint))
  result = call_598021.call(path_598022, query_598023, nil, nil, nil)

var accesscontextmanagerAccessPoliciesAccessLevelsDelete* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_598005(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsDelete",
    meth: HttpMethod.HttpDelete, host: "accesscontextmanager.googleapis.com",
    route: "/v1/{name}",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_598006,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_598007,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerOperationsCancel_598046 = ref object of OpenApiRestCall_597408
proc url_AccesscontextmanagerOperationsCancel_598048(protocol: Scheme;
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

proc validate_AccesscontextmanagerOperationsCancel_598047(path: JsonNode;
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
  var valid_598049 = path.getOrDefault("name")
  valid_598049 = validateParameter(valid_598049, JString, required = true,
                                 default = nil)
  if valid_598049 != nil:
    section.add "name", valid_598049
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
  var valid_598050 = query.getOrDefault("upload_protocol")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "upload_protocol", valid_598050
  var valid_598051 = query.getOrDefault("fields")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "fields", valid_598051
  var valid_598052 = query.getOrDefault("quotaUser")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "quotaUser", valid_598052
  var valid_598053 = query.getOrDefault("alt")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = newJString("json"))
  if valid_598053 != nil:
    section.add "alt", valid_598053
  var valid_598054 = query.getOrDefault("oauth_token")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "oauth_token", valid_598054
  var valid_598055 = query.getOrDefault("callback")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "callback", valid_598055
  var valid_598056 = query.getOrDefault("access_token")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "access_token", valid_598056
  var valid_598057 = query.getOrDefault("uploadType")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "uploadType", valid_598057
  var valid_598058 = query.getOrDefault("key")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "key", valid_598058
  var valid_598059 = query.getOrDefault("$.xgafv")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = newJString("1"))
  if valid_598059 != nil:
    section.add "$.xgafv", valid_598059
  var valid_598060 = query.getOrDefault("prettyPrint")
  valid_598060 = validateParameter(valid_598060, JBool, required = false,
                                 default = newJBool(true))
  if valid_598060 != nil:
    section.add "prettyPrint", valid_598060
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

proc call*(call_598062: Call_AccesscontextmanagerOperationsCancel_598046;
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
  let valid = call_598062.validator(path, query, header, formData, body)
  let scheme = call_598062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598062.url(scheme.get, call_598062.host, call_598062.base,
                         call_598062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598062, url, valid)

proc call*(call_598063: Call_AccesscontextmanagerOperationsCancel_598046;
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
  var path_598064 = newJObject()
  var query_598065 = newJObject()
  var body_598066 = newJObject()
  add(query_598065, "upload_protocol", newJString(uploadProtocol))
  add(query_598065, "fields", newJString(fields))
  add(query_598065, "quotaUser", newJString(quotaUser))
  add(path_598064, "name", newJString(name))
  add(query_598065, "alt", newJString(alt))
  add(query_598065, "oauth_token", newJString(oauthToken))
  add(query_598065, "callback", newJString(callback))
  add(query_598065, "access_token", newJString(accessToken))
  add(query_598065, "uploadType", newJString(uploadType))
  add(query_598065, "key", newJString(key))
  add(query_598065, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598066 = body
  add(query_598065, "prettyPrint", newJBool(prettyPrint))
  result = call_598063.call(path_598064, query_598065, nil, nil, body_598066)

var accesscontextmanagerOperationsCancel* = Call_AccesscontextmanagerOperationsCancel_598046(
    name: "accesscontextmanagerOperationsCancel", meth: HttpMethod.HttpPost,
    host: "accesscontextmanager.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_AccesscontextmanagerOperationsCancel_598047, base: "/",
    url: url_AccesscontextmanagerOperationsCancel_598048, schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_598089 = ref object of OpenApiRestCall_597408
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_598091(
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
               (kind: ConstantSegment, value: "/accessLevels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_598090(
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
  var valid_598092 = path.getOrDefault("parent")
  valid_598092 = validateParameter(valid_598092, JString, required = true,
                                 default = nil)
  if valid_598092 != nil:
    section.add "parent", valid_598092
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
  var valid_598093 = query.getOrDefault("upload_protocol")
  valid_598093 = validateParameter(valid_598093, JString, required = false,
                                 default = nil)
  if valid_598093 != nil:
    section.add "upload_protocol", valid_598093
  var valid_598094 = query.getOrDefault("fields")
  valid_598094 = validateParameter(valid_598094, JString, required = false,
                                 default = nil)
  if valid_598094 != nil:
    section.add "fields", valid_598094
  var valid_598095 = query.getOrDefault("quotaUser")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "quotaUser", valid_598095
  var valid_598096 = query.getOrDefault("alt")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = newJString("json"))
  if valid_598096 != nil:
    section.add "alt", valid_598096
  var valid_598097 = query.getOrDefault("oauth_token")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "oauth_token", valid_598097
  var valid_598098 = query.getOrDefault("callback")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "callback", valid_598098
  var valid_598099 = query.getOrDefault("access_token")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "access_token", valid_598099
  var valid_598100 = query.getOrDefault("uploadType")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "uploadType", valid_598100
  var valid_598101 = query.getOrDefault("key")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "key", valid_598101
  var valid_598102 = query.getOrDefault("$.xgafv")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = newJString("1"))
  if valid_598102 != nil:
    section.add "$.xgafv", valid_598102
  var valid_598103 = query.getOrDefault("prettyPrint")
  valid_598103 = validateParameter(valid_598103, JBool, required = false,
                                 default = newJBool(true))
  if valid_598103 != nil:
    section.add "prettyPrint", valid_598103
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

proc call*(call_598105: Call_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_598089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an Access Level. The longrunning
  ## operation from this RPC will have a successful status once the Access
  ## Level has
  ## propagated to long-lasting storage. Access Levels containing
  ## errors will result in an error response for the first error encountered.
  ## 
  let valid = call_598105.validator(path, query, header, formData, body)
  let scheme = call_598105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598105.url(scheme.get, call_598105.host, call_598105.base,
                         call_598105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598105, url, valid)

proc call*(call_598106: Call_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_598089;
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
  var path_598107 = newJObject()
  var query_598108 = newJObject()
  var body_598109 = newJObject()
  add(query_598108, "upload_protocol", newJString(uploadProtocol))
  add(query_598108, "fields", newJString(fields))
  add(query_598108, "quotaUser", newJString(quotaUser))
  add(query_598108, "alt", newJString(alt))
  add(query_598108, "oauth_token", newJString(oauthToken))
  add(query_598108, "callback", newJString(callback))
  add(query_598108, "access_token", newJString(accessToken))
  add(query_598108, "uploadType", newJString(uploadType))
  add(path_598107, "parent", newJString(parent))
  add(query_598108, "key", newJString(key))
  add(query_598108, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598109 = body
  add(query_598108, "prettyPrint", newJBool(prettyPrint))
  result = call_598106.call(path_598107, query_598108, nil, nil, body_598109)

var accesscontextmanagerAccessPoliciesAccessLevelsCreate* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_598089(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsCreate",
    meth: HttpMethod.HttpPost, host: "accesscontextmanager.googleapis.com",
    route: "/v1/{parent}/accessLevels",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_598090,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_598091,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsList_598067 = ref object of OpenApiRestCall_597408
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsList_598069(
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
               (kind: ConstantSegment, value: "/accessLevels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsList_598068(
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
  var valid_598070 = path.getOrDefault("parent")
  valid_598070 = validateParameter(valid_598070, JString, required = true,
                                 default = nil)
  if valid_598070 != nil:
    section.add "parent", valid_598070
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
  var valid_598071 = query.getOrDefault("upload_protocol")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "upload_protocol", valid_598071
  var valid_598072 = query.getOrDefault("fields")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "fields", valid_598072
  var valid_598073 = query.getOrDefault("pageToken")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "pageToken", valid_598073
  var valid_598074 = query.getOrDefault("quotaUser")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "quotaUser", valid_598074
  var valid_598075 = query.getOrDefault("alt")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = newJString("json"))
  if valid_598075 != nil:
    section.add "alt", valid_598075
  var valid_598076 = query.getOrDefault("oauth_token")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "oauth_token", valid_598076
  var valid_598077 = query.getOrDefault("callback")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "callback", valid_598077
  var valid_598078 = query.getOrDefault("access_token")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "access_token", valid_598078
  var valid_598079 = query.getOrDefault("uploadType")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "uploadType", valid_598079
  var valid_598080 = query.getOrDefault("key")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "key", valid_598080
  var valid_598081 = query.getOrDefault("$.xgafv")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = newJString("1"))
  if valid_598081 != nil:
    section.add "$.xgafv", valid_598081
  var valid_598082 = query.getOrDefault("pageSize")
  valid_598082 = validateParameter(valid_598082, JInt, required = false, default = nil)
  if valid_598082 != nil:
    section.add "pageSize", valid_598082
  var valid_598083 = query.getOrDefault("prettyPrint")
  valid_598083 = validateParameter(valid_598083, JBool, required = false,
                                 default = newJBool(true))
  if valid_598083 != nil:
    section.add "prettyPrint", valid_598083
  var valid_598084 = query.getOrDefault("accessLevelFormat")
  valid_598084 = validateParameter(valid_598084, JString, required = false, default = newJString(
      "LEVEL_FORMAT_UNSPECIFIED"))
  if valid_598084 != nil:
    section.add "accessLevelFormat", valid_598084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598085: Call_AccesscontextmanagerAccessPoliciesAccessLevelsList_598067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all Access Levels for an access
  ## policy.
  ## 
  let valid = call_598085.validator(path, query, header, formData, body)
  let scheme = call_598085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598085.url(scheme.get, call_598085.host, call_598085.base,
                         call_598085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598085, url, valid)

proc call*(call_598086: Call_AccesscontextmanagerAccessPoliciesAccessLevelsList_598067;
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
  var path_598087 = newJObject()
  var query_598088 = newJObject()
  add(query_598088, "upload_protocol", newJString(uploadProtocol))
  add(query_598088, "fields", newJString(fields))
  add(query_598088, "pageToken", newJString(pageToken))
  add(query_598088, "quotaUser", newJString(quotaUser))
  add(query_598088, "alt", newJString(alt))
  add(query_598088, "oauth_token", newJString(oauthToken))
  add(query_598088, "callback", newJString(callback))
  add(query_598088, "access_token", newJString(accessToken))
  add(query_598088, "uploadType", newJString(uploadType))
  add(path_598087, "parent", newJString(parent))
  add(query_598088, "key", newJString(key))
  add(query_598088, "$.xgafv", newJString(Xgafv))
  add(query_598088, "pageSize", newJInt(pageSize))
  add(query_598088, "prettyPrint", newJBool(prettyPrint))
  add(query_598088, "accessLevelFormat", newJString(accessLevelFormat))
  result = call_598086.call(path_598087, query_598088, nil, nil, nil)

var accesscontextmanagerAccessPoliciesAccessLevelsList* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsList_598067(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsList",
    meth: HttpMethod.HttpGet, host: "accesscontextmanager.googleapis.com",
    route: "/v1/{parent}/accessLevels",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsList_598068,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsList_598069,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_598131 = ref object of OpenApiRestCall_597408
proc url_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_598133(
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
               (kind: ConstantSegment, value: "/servicePerimeters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_598132(
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
  var valid_598134 = path.getOrDefault("parent")
  valid_598134 = validateParameter(valid_598134, JString, required = true,
                                 default = nil)
  if valid_598134 != nil:
    section.add "parent", valid_598134
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
  var valid_598135 = query.getOrDefault("upload_protocol")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "upload_protocol", valid_598135
  var valid_598136 = query.getOrDefault("fields")
  valid_598136 = validateParameter(valid_598136, JString, required = false,
                                 default = nil)
  if valid_598136 != nil:
    section.add "fields", valid_598136
  var valid_598137 = query.getOrDefault("quotaUser")
  valid_598137 = validateParameter(valid_598137, JString, required = false,
                                 default = nil)
  if valid_598137 != nil:
    section.add "quotaUser", valid_598137
  var valid_598138 = query.getOrDefault("alt")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = newJString("json"))
  if valid_598138 != nil:
    section.add "alt", valid_598138
  var valid_598139 = query.getOrDefault("oauth_token")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "oauth_token", valid_598139
  var valid_598140 = query.getOrDefault("callback")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "callback", valid_598140
  var valid_598141 = query.getOrDefault("access_token")
  valid_598141 = validateParameter(valid_598141, JString, required = false,
                                 default = nil)
  if valid_598141 != nil:
    section.add "access_token", valid_598141
  var valid_598142 = query.getOrDefault("uploadType")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "uploadType", valid_598142
  var valid_598143 = query.getOrDefault("key")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "key", valid_598143
  var valid_598144 = query.getOrDefault("$.xgafv")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = newJString("1"))
  if valid_598144 != nil:
    section.add "$.xgafv", valid_598144
  var valid_598145 = query.getOrDefault("prettyPrint")
  valid_598145 = validateParameter(valid_598145, JBool, required = false,
                                 default = newJBool(true))
  if valid_598145 != nil:
    section.add "prettyPrint", valid_598145
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

proc call*(call_598147: Call_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_598131;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an Service Perimeter. The
  ## longrunning operation from this RPC will have a successful status once the
  ## Service Perimeter has
  ## propagated to long-lasting storage. Service Perimeters containing
  ## errors will result in an error response for the first error encountered.
  ## 
  let valid = call_598147.validator(path, query, header, formData, body)
  let scheme = call_598147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598147.url(scheme.get, call_598147.host, call_598147.base,
                         call_598147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598147, url, valid)

proc call*(call_598148: Call_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_598131;
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
  var path_598149 = newJObject()
  var query_598150 = newJObject()
  var body_598151 = newJObject()
  add(query_598150, "upload_protocol", newJString(uploadProtocol))
  add(query_598150, "fields", newJString(fields))
  add(query_598150, "quotaUser", newJString(quotaUser))
  add(query_598150, "alt", newJString(alt))
  add(query_598150, "oauth_token", newJString(oauthToken))
  add(query_598150, "callback", newJString(callback))
  add(query_598150, "access_token", newJString(accessToken))
  add(query_598150, "uploadType", newJString(uploadType))
  add(path_598149, "parent", newJString(parent))
  add(query_598150, "key", newJString(key))
  add(query_598150, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598151 = body
  add(query_598150, "prettyPrint", newJBool(prettyPrint))
  result = call_598148.call(path_598149, query_598150, nil, nil, body_598151)

var accesscontextmanagerAccessPoliciesServicePerimetersCreate* = Call_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_598131(
    name: "accesscontextmanagerAccessPoliciesServicePerimetersCreate",
    meth: HttpMethod.HttpPost, host: "accesscontextmanager.googleapis.com",
    route: "/v1/{parent}/servicePerimeters", validator: validate_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_598132,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_598133,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesServicePerimetersList_598110 = ref object of OpenApiRestCall_597408
proc url_AccesscontextmanagerAccessPoliciesServicePerimetersList_598112(
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
               (kind: ConstantSegment, value: "/servicePerimeters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesServicePerimetersList_598111(
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
  var valid_598113 = path.getOrDefault("parent")
  valid_598113 = validateParameter(valid_598113, JString, required = true,
                                 default = nil)
  if valid_598113 != nil:
    section.add "parent", valid_598113
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
  var valid_598114 = query.getOrDefault("upload_protocol")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = nil)
  if valid_598114 != nil:
    section.add "upload_protocol", valid_598114
  var valid_598115 = query.getOrDefault("fields")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "fields", valid_598115
  var valid_598116 = query.getOrDefault("pageToken")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = nil)
  if valid_598116 != nil:
    section.add "pageToken", valid_598116
  var valid_598117 = query.getOrDefault("quotaUser")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "quotaUser", valid_598117
  var valid_598118 = query.getOrDefault("alt")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = newJString("json"))
  if valid_598118 != nil:
    section.add "alt", valid_598118
  var valid_598119 = query.getOrDefault("oauth_token")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "oauth_token", valid_598119
  var valid_598120 = query.getOrDefault("callback")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = nil)
  if valid_598120 != nil:
    section.add "callback", valid_598120
  var valid_598121 = query.getOrDefault("access_token")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "access_token", valid_598121
  var valid_598122 = query.getOrDefault("uploadType")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "uploadType", valid_598122
  var valid_598123 = query.getOrDefault("key")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "key", valid_598123
  var valid_598124 = query.getOrDefault("$.xgafv")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = newJString("1"))
  if valid_598124 != nil:
    section.add "$.xgafv", valid_598124
  var valid_598125 = query.getOrDefault("pageSize")
  valid_598125 = validateParameter(valid_598125, JInt, required = false, default = nil)
  if valid_598125 != nil:
    section.add "pageSize", valid_598125
  var valid_598126 = query.getOrDefault("prettyPrint")
  valid_598126 = validateParameter(valid_598126, JBool, required = false,
                                 default = newJBool(true))
  if valid_598126 != nil:
    section.add "prettyPrint", valid_598126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598127: Call_AccesscontextmanagerAccessPoliciesServicePerimetersList_598110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all Service Perimeters for an
  ## access policy.
  ## 
  let valid = call_598127.validator(path, query, header, formData, body)
  let scheme = call_598127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598127.url(scheme.get, call_598127.host, call_598127.base,
                         call_598127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598127, url, valid)

proc call*(call_598128: Call_AccesscontextmanagerAccessPoliciesServicePerimetersList_598110;
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
  var path_598129 = newJObject()
  var query_598130 = newJObject()
  add(query_598130, "upload_protocol", newJString(uploadProtocol))
  add(query_598130, "fields", newJString(fields))
  add(query_598130, "pageToken", newJString(pageToken))
  add(query_598130, "quotaUser", newJString(quotaUser))
  add(query_598130, "alt", newJString(alt))
  add(query_598130, "oauth_token", newJString(oauthToken))
  add(query_598130, "callback", newJString(callback))
  add(query_598130, "access_token", newJString(accessToken))
  add(query_598130, "uploadType", newJString(uploadType))
  add(path_598129, "parent", newJString(parent))
  add(query_598130, "key", newJString(key))
  add(query_598130, "$.xgafv", newJString(Xgafv))
  add(query_598130, "pageSize", newJInt(pageSize))
  add(query_598130, "prettyPrint", newJBool(prettyPrint))
  result = call_598128.call(path_598129, query_598130, nil, nil, nil)

var accesscontextmanagerAccessPoliciesServicePerimetersList* = Call_AccesscontextmanagerAccessPoliciesServicePerimetersList_598110(
    name: "accesscontextmanagerAccessPoliciesServicePerimetersList",
    meth: HttpMethod.HttpGet, host: "accesscontextmanager.googleapis.com",
    route: "/v1/{parent}/servicePerimeters", validator: validate_AccesscontextmanagerAccessPoliciesServicePerimetersList_598111,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesServicePerimetersList_598112,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
