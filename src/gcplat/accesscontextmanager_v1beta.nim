
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Access Context Manager
## version: v1beta
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
  gcpServiceName = "accesscontextmanager"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AccesscontextmanagerAccessPoliciesCreate_578885 = ref object of OpenApiRestCall_578339
proc url_AccesscontextmanagerAccessPoliciesCreate_578887(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AccesscontextmanagerAccessPoliciesCreate_578886(path: JsonNode;
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
  var valid_578888 = query.getOrDefault("key")
  valid_578888 = validateParameter(valid_578888, JString, required = false,
                                 default = nil)
  if valid_578888 != nil:
    section.add "key", valid_578888
  var valid_578889 = query.getOrDefault("prettyPrint")
  valid_578889 = validateParameter(valid_578889, JBool, required = false,
                                 default = newJBool(true))
  if valid_578889 != nil:
    section.add "prettyPrint", valid_578889
  var valid_578890 = query.getOrDefault("oauth_token")
  valid_578890 = validateParameter(valid_578890, JString, required = false,
                                 default = nil)
  if valid_578890 != nil:
    section.add "oauth_token", valid_578890
  var valid_578891 = query.getOrDefault("$.xgafv")
  valid_578891 = validateParameter(valid_578891, JString, required = false,
                                 default = newJString("1"))
  if valid_578891 != nil:
    section.add "$.xgafv", valid_578891
  var valid_578892 = query.getOrDefault("alt")
  valid_578892 = validateParameter(valid_578892, JString, required = false,
                                 default = newJString("json"))
  if valid_578892 != nil:
    section.add "alt", valid_578892
  var valid_578893 = query.getOrDefault("uploadType")
  valid_578893 = validateParameter(valid_578893, JString, required = false,
                                 default = nil)
  if valid_578893 != nil:
    section.add "uploadType", valid_578893
  var valid_578894 = query.getOrDefault("quotaUser")
  valid_578894 = validateParameter(valid_578894, JString, required = false,
                                 default = nil)
  if valid_578894 != nil:
    section.add "quotaUser", valid_578894
  var valid_578895 = query.getOrDefault("callback")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "callback", valid_578895
  var valid_578896 = query.getOrDefault("fields")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "fields", valid_578896
  var valid_578897 = query.getOrDefault("access_token")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "access_token", valid_578897
  var valid_578898 = query.getOrDefault("upload_protocol")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "upload_protocol", valid_578898
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

proc call*(call_578900: Call_AccesscontextmanagerAccessPoliciesCreate_578885;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an `AccessPolicy`. Fails if this organization already has a
  ## `AccessPolicy`. The longrunning Operation will have a successful status
  ## once the `AccessPolicy` has propagated to long-lasting storage.
  ## Syntactic and basic semantic errors will be returned in `metadata` as a
  ## BadRequest proto.
  ## 
  let valid = call_578900.validator(path, query, header, formData, body)
  let scheme = call_578900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578900.url(scheme.get, call_578900.host, call_578900.base,
                         call_578900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578900, url, valid)

proc call*(call_578901: Call_AccesscontextmanagerAccessPoliciesCreate_578885;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## accesscontextmanagerAccessPoliciesCreate
  ## Create an `AccessPolicy`. Fails if this organization already has a
  ## `AccessPolicy`. The longrunning Operation will have a successful status
  ## once the `AccessPolicy` has propagated to long-lasting storage.
  ## Syntactic and basic semantic errors will be returned in `metadata` as a
  ## BadRequest proto.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578902 = newJObject()
  var body_578903 = newJObject()
  add(query_578902, "key", newJString(key))
  add(query_578902, "prettyPrint", newJBool(prettyPrint))
  add(query_578902, "oauth_token", newJString(oauthToken))
  add(query_578902, "$.xgafv", newJString(Xgafv))
  add(query_578902, "alt", newJString(alt))
  add(query_578902, "uploadType", newJString(uploadType))
  add(query_578902, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578903 = body
  add(query_578902, "callback", newJString(callback))
  add(query_578902, "fields", newJString(fields))
  add(query_578902, "access_token", newJString(accessToken))
  add(query_578902, "upload_protocol", newJString(uploadProtocol))
  result = call_578901.call(nil, query_578902, nil, nil, body_578903)

var accesscontextmanagerAccessPoliciesCreate* = Call_AccesscontextmanagerAccessPoliciesCreate_578885(
    name: "accesscontextmanagerAccessPoliciesCreate", meth: HttpMethod.HttpPost,
    host: "accesscontextmanager.googleapis.com", route: "/v1beta/accessPolicies",
    validator: validate_AccesscontextmanagerAccessPoliciesCreate_578886,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesCreate_578887,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesList_578610 = ref object of OpenApiRestCall_578339
proc url_AccesscontextmanagerAccessPoliciesList_578612(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AccesscontextmanagerAccessPoliciesList_578611(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all AccessPolicies under a
  ## container.
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
  ##           : Number of AccessPolicy instances to include in the list. Default 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : Required. Resource name for the container to list AccessPolicy instances
  ## from.
  ## 
  ## Format:
  ## `organizations/{org_id}`
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Next page token for the next batch of AccessPolicy instances. Defaults to
  ## the first page of results.
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
  var valid_578744 = query.getOrDefault("parent")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "parent", valid_578744
  var valid_578745 = query.getOrDefault("quotaUser")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "quotaUser", valid_578745
  var valid_578746 = query.getOrDefault("pageToken")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "pageToken", valid_578746
  var valid_578747 = query.getOrDefault("callback")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "callback", valid_578747
  var valid_578748 = query.getOrDefault("fields")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "fields", valid_578748
  var valid_578749 = query.getOrDefault("access_token")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "access_token", valid_578749
  var valid_578750 = query.getOrDefault("upload_protocol")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "upload_protocol", valid_578750
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578773: Call_AccesscontextmanagerAccessPoliciesList_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all AccessPolicies under a
  ## container.
  ## 
  let valid = call_578773.validator(path, query, header, formData, body)
  let scheme = call_578773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578773.url(scheme.get, call_578773.host, call_578773.base,
                         call_578773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578773, url, valid)

proc call*(call_578844: Call_AccesscontextmanagerAccessPoliciesList_578610;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## accesscontextmanagerAccessPoliciesList
  ## List all AccessPolicies under a
  ## container.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of AccessPolicy instances to include in the list. Default 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : Required. Resource name for the container to list AccessPolicy instances
  ## from.
  ## 
  ## Format:
  ## `organizations/{org_id}`
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Next page token for the next batch of AccessPolicy instances. Defaults to
  ## the first page of results.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578845 = newJObject()
  add(query_578845, "key", newJString(key))
  add(query_578845, "prettyPrint", newJBool(prettyPrint))
  add(query_578845, "oauth_token", newJString(oauthToken))
  add(query_578845, "$.xgafv", newJString(Xgafv))
  add(query_578845, "pageSize", newJInt(pageSize))
  add(query_578845, "alt", newJString(alt))
  add(query_578845, "uploadType", newJString(uploadType))
  add(query_578845, "parent", newJString(parent))
  add(query_578845, "quotaUser", newJString(quotaUser))
  add(query_578845, "pageToken", newJString(pageToken))
  add(query_578845, "callback", newJString(callback))
  add(query_578845, "fields", newJString(fields))
  add(query_578845, "access_token", newJString(accessToken))
  add(query_578845, "upload_protocol", newJString(uploadProtocol))
  result = call_578844.call(nil, query_578845, nil, nil, nil)

var accesscontextmanagerAccessPoliciesList* = Call_AccesscontextmanagerAccessPoliciesList_578610(
    name: "accesscontextmanagerAccessPoliciesList", meth: HttpMethod.HttpGet,
    host: "accesscontextmanager.googleapis.com", route: "/v1beta/accessPolicies",
    validator: validate_AccesscontextmanagerAccessPoliciesList_578611, base: "/",
    url: url_AccesscontextmanagerAccessPoliciesList_578612,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsGet_578904 = ref object of OpenApiRestCall_578339
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsGet_578906(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsGet_578905(
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
  var valid_578921 = path.getOrDefault("name")
  valid_578921 = validateParameter(valid_578921, JString, required = true,
                                 default = nil)
  if valid_578921 != nil:
    section.add "name", valid_578921
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
  ##   accessLevelFormat: JString
  ##                    : Whether to return `BasicLevels` in the Cloud Common Expression
  ## Language rather than as `BasicLevels`. Defaults to AS_DEFINED, where
  ## Access Levels
  ## are returned as `BasicLevels` or `CustomLevels` based on how they were
  ## created. If set to CEL, all Access Levels are returned as
  ## `CustomLevels`. In the CEL case, `BasicLevels` are translated to equivalent
  ## `CustomLevels`.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578922 = query.getOrDefault("key")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "key", valid_578922
  var valid_578923 = query.getOrDefault("prettyPrint")
  valid_578923 = validateParameter(valid_578923, JBool, required = false,
                                 default = newJBool(true))
  if valid_578923 != nil:
    section.add "prettyPrint", valid_578923
  var valid_578924 = query.getOrDefault("oauth_token")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "oauth_token", valid_578924
  var valid_578925 = query.getOrDefault("$.xgafv")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = newJString("1"))
  if valid_578925 != nil:
    section.add "$.xgafv", valid_578925
  var valid_578926 = query.getOrDefault("alt")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = newJString("json"))
  if valid_578926 != nil:
    section.add "alt", valid_578926
  var valid_578927 = query.getOrDefault("uploadType")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "uploadType", valid_578927
  var valid_578928 = query.getOrDefault("quotaUser")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "quotaUser", valid_578928
  var valid_578929 = query.getOrDefault("callback")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "callback", valid_578929
  var valid_578930 = query.getOrDefault("accessLevelFormat")
  valid_578930 = validateParameter(valid_578930, JString, required = false, default = newJString(
      "LEVEL_FORMAT_UNSPECIFIED"))
  if valid_578930 != nil:
    section.add "accessLevelFormat", valid_578930
  var valid_578931 = query.getOrDefault("fields")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "fields", valid_578931
  var valid_578932 = query.getOrDefault("access_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "access_token", valid_578932
  var valid_578933 = query.getOrDefault("upload_protocol")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "upload_protocol", valid_578933
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578934: Call_AccesscontextmanagerAccessPoliciesAccessLevelsGet_578904;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an Access Level by resource
  ## name.
  ## 
  let valid = call_578934.validator(path, query, header, formData, body)
  let scheme = call_578934.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578934.url(scheme.get, call_578934.host, call_578934.base,
                         call_578934.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578934, url, valid)

proc call*(call_578935: Call_AccesscontextmanagerAccessPoliciesAccessLevelsGet_578904;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          accessLevelFormat: string = "LEVEL_FORMAT_UNSPECIFIED";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## accesscontextmanagerAccessPoliciesAccessLevelsGet
  ## Get an Access Level by resource
  ## name.
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
  ##       : Required. Resource name for the Access Level.
  ## 
  ## Format:
  ## `accessPolicies/{policy_id}/accessLevels/{access_level_id}`
  ##   callback: string
  ##           : JSONP
  ##   accessLevelFormat: string
  ##                    : Whether to return `BasicLevels` in the Cloud Common Expression
  ## Language rather than as `BasicLevels`. Defaults to AS_DEFINED, where
  ## Access Levels
  ## are returned as `BasicLevels` or `CustomLevels` based on how they were
  ## created. If set to CEL, all Access Levels are returned as
  ## `CustomLevels`. In the CEL case, `BasicLevels` are translated to equivalent
  ## `CustomLevels`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578936 = newJObject()
  var query_578937 = newJObject()
  add(query_578937, "key", newJString(key))
  add(query_578937, "prettyPrint", newJBool(prettyPrint))
  add(query_578937, "oauth_token", newJString(oauthToken))
  add(query_578937, "$.xgafv", newJString(Xgafv))
  add(query_578937, "alt", newJString(alt))
  add(query_578937, "uploadType", newJString(uploadType))
  add(query_578937, "quotaUser", newJString(quotaUser))
  add(path_578936, "name", newJString(name))
  add(query_578937, "callback", newJString(callback))
  add(query_578937, "accessLevelFormat", newJString(accessLevelFormat))
  add(query_578937, "fields", newJString(fields))
  add(query_578937, "access_token", newJString(accessToken))
  add(query_578937, "upload_protocol", newJString(uploadProtocol))
  result = call_578935.call(path_578936, query_578937, nil, nil, nil)

var accesscontextmanagerAccessPoliciesAccessLevelsGet* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsGet_578904(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsGet",
    meth: HttpMethod.HttpGet, host: "accesscontextmanager.googleapis.com",
    route: "/v1beta/{name}",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsGet_578905,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsGet_578906,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_578957 = ref object of OpenApiRestCall_578339
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_578959(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_578958(
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
  var valid_578960 = path.getOrDefault("name")
  valid_578960 = validateParameter(valid_578960, JString, required = true,
                                 default = nil)
  if valid_578960 != nil:
    section.add "name", valid_578960
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
  ##             : Required. Mask to control which fields get updated. Must be non-empty.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578961 = query.getOrDefault("key")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "key", valid_578961
  var valid_578962 = query.getOrDefault("prettyPrint")
  valid_578962 = validateParameter(valid_578962, JBool, required = false,
                                 default = newJBool(true))
  if valid_578962 != nil:
    section.add "prettyPrint", valid_578962
  var valid_578963 = query.getOrDefault("oauth_token")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "oauth_token", valid_578963
  var valid_578964 = query.getOrDefault("$.xgafv")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = newJString("1"))
  if valid_578964 != nil:
    section.add "$.xgafv", valid_578964
  var valid_578965 = query.getOrDefault("alt")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = newJString("json"))
  if valid_578965 != nil:
    section.add "alt", valid_578965
  var valid_578966 = query.getOrDefault("uploadType")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "uploadType", valid_578966
  var valid_578967 = query.getOrDefault("quotaUser")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "quotaUser", valid_578967
  var valid_578968 = query.getOrDefault("updateMask")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "updateMask", valid_578968
  var valid_578969 = query.getOrDefault("callback")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "callback", valid_578969
  var valid_578970 = query.getOrDefault("fields")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "fields", valid_578970
  var valid_578971 = query.getOrDefault("access_token")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "access_token", valid_578971
  var valid_578972 = query.getOrDefault("upload_protocol")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "upload_protocol", valid_578972
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

proc call*(call_578974: Call_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_578957;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an Access Level. The longrunning
  ## operation from this RPC will have a successful status once the changes to
  ## the Access Level have propagated
  ## to long-lasting storage. Access Levels containing
  ## errors will result in an error response for the first error encountered.
  ## 
  let valid = call_578974.validator(path, query, header, formData, body)
  let scheme = call_578974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578974.url(scheme.get, call_578974.host, call_578974.base,
                         call_578974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578974, url, valid)

proc call*(call_578975: Call_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_578957;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## accesscontextmanagerAccessPoliciesAccessLevelsPatch
  ## Update an Access Level. The longrunning
  ## operation from this RPC will have a successful status once the changes to
  ## the Access Level have propagated
  ## to long-lasting storage. Access Levels containing
  ## errors will result in an error response for the first error encountered.
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
  ##       : Required. Resource name for the Access Level. The `short_name` component
  ## must begin with a letter and only include alphanumeric and '_'. Format:
  ## `accessPolicies/{policy_id}/accessLevels/{short_name}`
  ##   updateMask: string
  ##             : Required. Mask to control which fields get updated. Must be non-empty.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578976 = newJObject()
  var query_578977 = newJObject()
  var body_578978 = newJObject()
  add(query_578977, "key", newJString(key))
  add(query_578977, "prettyPrint", newJBool(prettyPrint))
  add(query_578977, "oauth_token", newJString(oauthToken))
  add(query_578977, "$.xgafv", newJString(Xgafv))
  add(query_578977, "alt", newJString(alt))
  add(query_578977, "uploadType", newJString(uploadType))
  add(query_578977, "quotaUser", newJString(quotaUser))
  add(path_578976, "name", newJString(name))
  add(query_578977, "updateMask", newJString(updateMask))
  if body != nil:
    body_578978 = body
  add(query_578977, "callback", newJString(callback))
  add(query_578977, "fields", newJString(fields))
  add(query_578977, "access_token", newJString(accessToken))
  add(query_578977, "upload_protocol", newJString(uploadProtocol))
  result = call_578975.call(path_578976, query_578977, nil, nil, body_578978)

var accesscontextmanagerAccessPoliciesAccessLevelsPatch* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_578957(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsPatch",
    meth: HttpMethod.HttpPatch, host: "accesscontextmanager.googleapis.com",
    route: "/v1beta/{name}",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_578958,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsPatch_578959,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_578938 = ref object of OpenApiRestCall_578339
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_578940(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_578939(
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
  var valid_578941 = path.getOrDefault("name")
  valid_578941 = validateParameter(valid_578941, JString, required = true,
                                 default = nil)
  if valid_578941 != nil:
    section.add "name", valid_578941
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
  var valid_578942 = query.getOrDefault("key")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "key", valid_578942
  var valid_578943 = query.getOrDefault("prettyPrint")
  valid_578943 = validateParameter(valid_578943, JBool, required = false,
                                 default = newJBool(true))
  if valid_578943 != nil:
    section.add "prettyPrint", valid_578943
  var valid_578944 = query.getOrDefault("oauth_token")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "oauth_token", valid_578944
  var valid_578945 = query.getOrDefault("$.xgafv")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = newJString("1"))
  if valid_578945 != nil:
    section.add "$.xgafv", valid_578945
  var valid_578946 = query.getOrDefault("alt")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = newJString("json"))
  if valid_578946 != nil:
    section.add "alt", valid_578946
  var valid_578947 = query.getOrDefault("uploadType")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "uploadType", valid_578947
  var valid_578948 = query.getOrDefault("quotaUser")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "quotaUser", valid_578948
  var valid_578949 = query.getOrDefault("callback")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "callback", valid_578949
  var valid_578950 = query.getOrDefault("fields")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "fields", valid_578950
  var valid_578951 = query.getOrDefault("access_token")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "access_token", valid_578951
  var valid_578952 = query.getOrDefault("upload_protocol")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "upload_protocol", valid_578952
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578953: Call_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_578938;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an Access Level by resource
  ## name. The longrunning operation from this RPC will have a successful status
  ## once the Access Level has been removed
  ## from long-lasting storage.
  ## 
  let valid = call_578953.validator(path, query, header, formData, body)
  let scheme = call_578953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578953.url(scheme.get, call_578953.host, call_578953.base,
                         call_578953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578953, url, valid)

proc call*(call_578954: Call_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_578938;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## accesscontextmanagerAccessPoliciesAccessLevelsDelete
  ## Delete an Access Level by resource
  ## name. The longrunning operation from this RPC will have a successful status
  ## once the Access Level has been removed
  ## from long-lasting storage.
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
  ##       : Required. Resource name for the Access Level.
  ## 
  ## Format:
  ## `accessPolicies/{policy_id}/accessLevels/{access_level_id}`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578955 = newJObject()
  var query_578956 = newJObject()
  add(query_578956, "key", newJString(key))
  add(query_578956, "prettyPrint", newJBool(prettyPrint))
  add(query_578956, "oauth_token", newJString(oauthToken))
  add(query_578956, "$.xgafv", newJString(Xgafv))
  add(query_578956, "alt", newJString(alt))
  add(query_578956, "uploadType", newJString(uploadType))
  add(query_578956, "quotaUser", newJString(quotaUser))
  add(path_578955, "name", newJString(name))
  add(query_578956, "callback", newJString(callback))
  add(query_578956, "fields", newJString(fields))
  add(query_578956, "access_token", newJString(accessToken))
  add(query_578956, "upload_protocol", newJString(uploadProtocol))
  result = call_578954.call(path_578955, query_578956, nil, nil, nil)

var accesscontextmanagerAccessPoliciesAccessLevelsDelete* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_578938(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsDelete",
    meth: HttpMethod.HttpDelete, host: "accesscontextmanager.googleapis.com",
    route: "/v1beta/{name}",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_578939,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsDelete_578940,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_579001 = ref object of OpenApiRestCall_578339
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_579003(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/accessLevels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_579002(
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
  var valid_579004 = path.getOrDefault("parent")
  valid_579004 = validateParameter(valid_579004, JString, required = true,
                                 default = nil)
  if valid_579004 != nil:
    section.add "parent", valid_579004
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
  var valid_579005 = query.getOrDefault("key")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "key", valid_579005
  var valid_579006 = query.getOrDefault("prettyPrint")
  valid_579006 = validateParameter(valid_579006, JBool, required = false,
                                 default = newJBool(true))
  if valid_579006 != nil:
    section.add "prettyPrint", valid_579006
  var valid_579007 = query.getOrDefault("oauth_token")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "oauth_token", valid_579007
  var valid_579008 = query.getOrDefault("$.xgafv")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = newJString("1"))
  if valid_579008 != nil:
    section.add "$.xgafv", valid_579008
  var valid_579009 = query.getOrDefault("alt")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = newJString("json"))
  if valid_579009 != nil:
    section.add "alt", valid_579009
  var valid_579010 = query.getOrDefault("uploadType")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "uploadType", valid_579010
  var valid_579011 = query.getOrDefault("quotaUser")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "quotaUser", valid_579011
  var valid_579012 = query.getOrDefault("callback")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "callback", valid_579012
  var valid_579013 = query.getOrDefault("fields")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "fields", valid_579013
  var valid_579014 = query.getOrDefault("access_token")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "access_token", valid_579014
  var valid_579015 = query.getOrDefault("upload_protocol")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "upload_protocol", valid_579015
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

proc call*(call_579017: Call_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_579001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an Access Level. The longrunning
  ## operation from this RPC will have a successful status once the Access
  ## Level has
  ## propagated to long-lasting storage. Access Levels containing
  ## errors will result in an error response for the first error encountered.
  ## 
  let valid = call_579017.validator(path, query, header, formData, body)
  let scheme = call_579017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579017.url(scheme.get, call_579017.host, call_579017.base,
                         call_579017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579017, url, valid)

proc call*(call_579018: Call_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_579001;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## accesscontextmanagerAccessPoliciesAccessLevelsCreate
  ## Create an Access Level. The longrunning
  ## operation from this RPC will have a successful status once the Access
  ## Level has
  ## propagated to long-lasting storage. Access Levels containing
  ## errors will result in an error response for the first error encountered.
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
  ##         : Required. Resource name for the access policy which owns this Access
  ## Level.
  ## 
  ## Format: `accessPolicies/{policy_id}`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579019 = newJObject()
  var query_579020 = newJObject()
  var body_579021 = newJObject()
  add(query_579020, "key", newJString(key))
  add(query_579020, "prettyPrint", newJBool(prettyPrint))
  add(query_579020, "oauth_token", newJString(oauthToken))
  add(query_579020, "$.xgafv", newJString(Xgafv))
  add(query_579020, "alt", newJString(alt))
  add(query_579020, "uploadType", newJString(uploadType))
  add(query_579020, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579021 = body
  add(query_579020, "callback", newJString(callback))
  add(path_579019, "parent", newJString(parent))
  add(query_579020, "fields", newJString(fields))
  add(query_579020, "access_token", newJString(accessToken))
  add(query_579020, "upload_protocol", newJString(uploadProtocol))
  result = call_579018.call(path_579019, query_579020, nil, nil, body_579021)

var accesscontextmanagerAccessPoliciesAccessLevelsCreate* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_579001(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsCreate",
    meth: HttpMethod.HttpPost, host: "accesscontextmanager.googleapis.com",
    route: "/v1beta/{parent}/accessLevels",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_579002,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_579003,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsList_578979 = ref object of OpenApiRestCall_578339
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsList_578981(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/accessLevels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsList_578980(
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
  var valid_578982 = path.getOrDefault("parent")
  valid_578982 = validateParameter(valid_578982, JString, required = true,
                                 default = nil)
  if valid_578982 != nil:
    section.add "parent", valid_578982
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
  ##           : Number of Access Levels to include in
  ## the list. Default 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Next page token for the next batch of Access Level instances.
  ## Defaults to the first page of results.
  ##   callback: JString
  ##           : JSONP
  ##   accessLevelFormat: JString
  ##                    : Whether to return `BasicLevels` in the Cloud Common Expression language, as
  ## `CustomLevels`, rather than as `BasicLevels`. Defaults to returning
  ## `AccessLevels` in the format they were defined.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578983 = query.getOrDefault("key")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "key", valid_578983
  var valid_578984 = query.getOrDefault("prettyPrint")
  valid_578984 = validateParameter(valid_578984, JBool, required = false,
                                 default = newJBool(true))
  if valid_578984 != nil:
    section.add "prettyPrint", valid_578984
  var valid_578985 = query.getOrDefault("oauth_token")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "oauth_token", valid_578985
  var valid_578986 = query.getOrDefault("$.xgafv")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = newJString("1"))
  if valid_578986 != nil:
    section.add "$.xgafv", valid_578986
  var valid_578987 = query.getOrDefault("pageSize")
  valid_578987 = validateParameter(valid_578987, JInt, required = false, default = nil)
  if valid_578987 != nil:
    section.add "pageSize", valid_578987
  var valid_578988 = query.getOrDefault("alt")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = newJString("json"))
  if valid_578988 != nil:
    section.add "alt", valid_578988
  var valid_578989 = query.getOrDefault("uploadType")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "uploadType", valid_578989
  var valid_578990 = query.getOrDefault("quotaUser")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "quotaUser", valid_578990
  var valid_578991 = query.getOrDefault("pageToken")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "pageToken", valid_578991
  var valid_578992 = query.getOrDefault("callback")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "callback", valid_578992
  var valid_578993 = query.getOrDefault("accessLevelFormat")
  valid_578993 = validateParameter(valid_578993, JString, required = false, default = newJString(
      "LEVEL_FORMAT_UNSPECIFIED"))
  if valid_578993 != nil:
    section.add "accessLevelFormat", valid_578993
  var valid_578994 = query.getOrDefault("fields")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "fields", valid_578994
  var valid_578995 = query.getOrDefault("access_token")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "access_token", valid_578995
  var valid_578996 = query.getOrDefault("upload_protocol")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "upload_protocol", valid_578996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578997: Call_AccesscontextmanagerAccessPoliciesAccessLevelsList_578979;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all Access Levels for an access
  ## policy.
  ## 
  let valid = call_578997.validator(path, query, header, formData, body)
  let scheme = call_578997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578997.url(scheme.get, call_578997.host, call_578997.base,
                         call_578997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578997, url, valid)

proc call*(call_578998: Call_AccesscontextmanagerAccessPoliciesAccessLevelsList_578979;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = "";
          accessLevelFormat: string = "LEVEL_FORMAT_UNSPECIFIED";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## accesscontextmanagerAccessPoliciesAccessLevelsList
  ## List all Access Levels for an access
  ## policy.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of Access Levels to include in
  ## the list. Default 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Next page token for the next batch of Access Level instances.
  ## Defaults to the first page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. Resource name for the access policy to list Access Levels from.
  ## 
  ## Format:
  ## `accessPolicies/{policy_id}`
  ##   accessLevelFormat: string
  ##                    : Whether to return `BasicLevels` in the Cloud Common Expression language, as
  ## `CustomLevels`, rather than as `BasicLevels`. Defaults to returning
  ## `AccessLevels` in the format they were defined.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578999 = newJObject()
  var query_579000 = newJObject()
  add(query_579000, "key", newJString(key))
  add(query_579000, "prettyPrint", newJBool(prettyPrint))
  add(query_579000, "oauth_token", newJString(oauthToken))
  add(query_579000, "$.xgafv", newJString(Xgafv))
  add(query_579000, "pageSize", newJInt(pageSize))
  add(query_579000, "alt", newJString(alt))
  add(query_579000, "uploadType", newJString(uploadType))
  add(query_579000, "quotaUser", newJString(quotaUser))
  add(query_579000, "pageToken", newJString(pageToken))
  add(query_579000, "callback", newJString(callback))
  add(path_578999, "parent", newJString(parent))
  add(query_579000, "accessLevelFormat", newJString(accessLevelFormat))
  add(query_579000, "fields", newJString(fields))
  add(query_579000, "access_token", newJString(accessToken))
  add(query_579000, "upload_protocol", newJString(uploadProtocol))
  result = call_578998.call(path_578999, query_579000, nil, nil, nil)

var accesscontextmanagerAccessPoliciesAccessLevelsList* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsList_578979(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsList",
    meth: HttpMethod.HttpGet, host: "accesscontextmanager.googleapis.com",
    route: "/v1beta/{parent}/accessLevels",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsList_578980,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsList_578981,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_579043 = ref object of OpenApiRestCall_578339
proc url_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_579045(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/servicePerimeters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_579044(
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
  var valid_579046 = path.getOrDefault("parent")
  valid_579046 = validateParameter(valid_579046, JString, required = true,
                                 default = nil)
  if valid_579046 != nil:
    section.add "parent", valid_579046
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
  var valid_579047 = query.getOrDefault("key")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "key", valid_579047
  var valid_579048 = query.getOrDefault("prettyPrint")
  valid_579048 = validateParameter(valid_579048, JBool, required = false,
                                 default = newJBool(true))
  if valid_579048 != nil:
    section.add "prettyPrint", valid_579048
  var valid_579049 = query.getOrDefault("oauth_token")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "oauth_token", valid_579049
  var valid_579050 = query.getOrDefault("$.xgafv")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = newJString("1"))
  if valid_579050 != nil:
    section.add "$.xgafv", valid_579050
  var valid_579051 = query.getOrDefault("alt")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = newJString("json"))
  if valid_579051 != nil:
    section.add "alt", valid_579051
  var valid_579052 = query.getOrDefault("uploadType")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "uploadType", valid_579052
  var valid_579053 = query.getOrDefault("quotaUser")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "quotaUser", valid_579053
  var valid_579054 = query.getOrDefault("callback")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "callback", valid_579054
  var valid_579055 = query.getOrDefault("fields")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "fields", valid_579055
  var valid_579056 = query.getOrDefault("access_token")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "access_token", valid_579056
  var valid_579057 = query.getOrDefault("upload_protocol")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "upload_protocol", valid_579057
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

proc call*(call_579059: Call_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_579043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an Service Perimeter. The
  ## longrunning operation from this RPC will have a successful status once the
  ## Service Perimeter has
  ## propagated to long-lasting storage. Service Perimeters containing
  ## errors will result in an error response for the first error encountered.
  ## 
  let valid = call_579059.validator(path, query, header, formData, body)
  let scheme = call_579059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579059.url(scheme.get, call_579059.host, call_579059.base,
                         call_579059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579059, url, valid)

proc call*(call_579060: Call_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_579043;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## accesscontextmanagerAccessPoliciesServicePerimetersCreate
  ## Create an Service Perimeter. The
  ## longrunning operation from this RPC will have a successful status once the
  ## Service Perimeter has
  ## propagated to long-lasting storage. Service Perimeters containing
  ## errors will result in an error response for the first error encountered.
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
  ##         : Required. Resource name for the access policy which owns this Service
  ## Perimeter.
  ## 
  ## Format: `accessPolicies/{policy_id}`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579061 = newJObject()
  var query_579062 = newJObject()
  var body_579063 = newJObject()
  add(query_579062, "key", newJString(key))
  add(query_579062, "prettyPrint", newJBool(prettyPrint))
  add(query_579062, "oauth_token", newJString(oauthToken))
  add(query_579062, "$.xgafv", newJString(Xgafv))
  add(query_579062, "alt", newJString(alt))
  add(query_579062, "uploadType", newJString(uploadType))
  add(query_579062, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579063 = body
  add(query_579062, "callback", newJString(callback))
  add(path_579061, "parent", newJString(parent))
  add(query_579062, "fields", newJString(fields))
  add(query_579062, "access_token", newJString(accessToken))
  add(query_579062, "upload_protocol", newJString(uploadProtocol))
  result = call_579060.call(path_579061, query_579062, nil, nil, body_579063)

var accesscontextmanagerAccessPoliciesServicePerimetersCreate* = Call_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_579043(
    name: "accesscontextmanagerAccessPoliciesServicePerimetersCreate",
    meth: HttpMethod.HttpPost, host: "accesscontextmanager.googleapis.com",
    route: "/v1beta/{parent}/servicePerimeters", validator: validate_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_579044,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_579045,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesServicePerimetersList_579022 = ref object of OpenApiRestCall_578339
proc url_AccesscontextmanagerAccessPoliciesServicePerimetersList_579024(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/servicePerimeters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesServicePerimetersList_579023(
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
  var valid_579025 = path.getOrDefault("parent")
  valid_579025 = validateParameter(valid_579025, JString, required = true,
                                 default = nil)
  if valid_579025 != nil:
    section.add "parent", valid_579025
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
  ##           : Number of Service Perimeters to include
  ## in the list. Default 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Next page token for the next batch of Service Perimeter instances.
  ## Defaults to the first page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579026 = query.getOrDefault("key")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "key", valid_579026
  var valid_579027 = query.getOrDefault("prettyPrint")
  valid_579027 = validateParameter(valid_579027, JBool, required = false,
                                 default = newJBool(true))
  if valid_579027 != nil:
    section.add "prettyPrint", valid_579027
  var valid_579028 = query.getOrDefault("oauth_token")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "oauth_token", valid_579028
  var valid_579029 = query.getOrDefault("$.xgafv")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = newJString("1"))
  if valid_579029 != nil:
    section.add "$.xgafv", valid_579029
  var valid_579030 = query.getOrDefault("pageSize")
  valid_579030 = validateParameter(valid_579030, JInt, required = false, default = nil)
  if valid_579030 != nil:
    section.add "pageSize", valid_579030
  var valid_579031 = query.getOrDefault("alt")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = newJString("json"))
  if valid_579031 != nil:
    section.add "alt", valid_579031
  var valid_579032 = query.getOrDefault("uploadType")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "uploadType", valid_579032
  var valid_579033 = query.getOrDefault("quotaUser")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "quotaUser", valid_579033
  var valid_579034 = query.getOrDefault("pageToken")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "pageToken", valid_579034
  var valid_579035 = query.getOrDefault("callback")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "callback", valid_579035
  var valid_579036 = query.getOrDefault("fields")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "fields", valid_579036
  var valid_579037 = query.getOrDefault("access_token")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "access_token", valid_579037
  var valid_579038 = query.getOrDefault("upload_protocol")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "upload_protocol", valid_579038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579039: Call_AccesscontextmanagerAccessPoliciesServicePerimetersList_579022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all Service Perimeters for an
  ## access policy.
  ## 
  let valid = call_579039.validator(path, query, header, formData, body)
  let scheme = call_579039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579039.url(scheme.get, call_579039.host, call_579039.base,
                         call_579039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579039, url, valid)

proc call*(call_579040: Call_AccesscontextmanagerAccessPoliciesServicePerimetersList_579022;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## accesscontextmanagerAccessPoliciesServicePerimetersList
  ## List all Service Perimeters for an
  ## access policy.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of Service Perimeters to include
  ## in the list. Default 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Next page token for the next batch of Service Perimeter instances.
  ## Defaults to the first page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. Resource name for the access policy to list Service Perimeters from.
  ## 
  ## Format:
  ## `accessPolicies/{policy_id}`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579041 = newJObject()
  var query_579042 = newJObject()
  add(query_579042, "key", newJString(key))
  add(query_579042, "prettyPrint", newJBool(prettyPrint))
  add(query_579042, "oauth_token", newJString(oauthToken))
  add(query_579042, "$.xgafv", newJString(Xgafv))
  add(query_579042, "pageSize", newJInt(pageSize))
  add(query_579042, "alt", newJString(alt))
  add(query_579042, "uploadType", newJString(uploadType))
  add(query_579042, "quotaUser", newJString(quotaUser))
  add(query_579042, "pageToken", newJString(pageToken))
  add(query_579042, "callback", newJString(callback))
  add(path_579041, "parent", newJString(parent))
  add(query_579042, "fields", newJString(fields))
  add(query_579042, "access_token", newJString(accessToken))
  add(query_579042, "upload_protocol", newJString(uploadProtocol))
  result = call_579040.call(path_579041, query_579042, nil, nil, nil)

var accesscontextmanagerAccessPoliciesServicePerimetersList* = Call_AccesscontextmanagerAccessPoliciesServicePerimetersList_579022(
    name: "accesscontextmanagerAccessPoliciesServicePerimetersList",
    meth: HttpMethod.HttpGet, host: "accesscontextmanager.googleapis.com",
    route: "/v1beta/{parent}/servicePerimeters", validator: validate_AccesscontextmanagerAccessPoliciesServicePerimetersList_579023,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesServicePerimetersList_579024,
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
