
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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
  gcpServiceName = "accesscontextmanager"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AccesscontextmanagerAccessPoliciesCreate_579910 = ref object of OpenApiRestCall_579364
proc url_AccesscontextmanagerAccessPoliciesCreate_579912(protocol: Scheme;
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

proc validate_AccesscontextmanagerAccessPoliciesCreate_579911(path: JsonNode;
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
  var valid_579913 = query.getOrDefault("key")
  valid_579913 = validateParameter(valid_579913, JString, required = false,
                                 default = nil)
  if valid_579913 != nil:
    section.add "key", valid_579913
  var valid_579914 = query.getOrDefault("prettyPrint")
  valid_579914 = validateParameter(valid_579914, JBool, required = false,
                                 default = newJBool(true))
  if valid_579914 != nil:
    section.add "prettyPrint", valid_579914
  var valid_579915 = query.getOrDefault("oauth_token")
  valid_579915 = validateParameter(valid_579915, JString, required = false,
                                 default = nil)
  if valid_579915 != nil:
    section.add "oauth_token", valid_579915
  var valid_579916 = query.getOrDefault("$.xgafv")
  valid_579916 = validateParameter(valid_579916, JString, required = false,
                                 default = newJString("1"))
  if valid_579916 != nil:
    section.add "$.xgafv", valid_579916
  var valid_579917 = query.getOrDefault("alt")
  valid_579917 = validateParameter(valid_579917, JString, required = false,
                                 default = newJString("json"))
  if valid_579917 != nil:
    section.add "alt", valid_579917
  var valid_579918 = query.getOrDefault("uploadType")
  valid_579918 = validateParameter(valid_579918, JString, required = false,
                                 default = nil)
  if valid_579918 != nil:
    section.add "uploadType", valid_579918
  var valid_579919 = query.getOrDefault("quotaUser")
  valid_579919 = validateParameter(valid_579919, JString, required = false,
                                 default = nil)
  if valid_579919 != nil:
    section.add "quotaUser", valid_579919
  var valid_579920 = query.getOrDefault("callback")
  valid_579920 = validateParameter(valid_579920, JString, required = false,
                                 default = nil)
  if valid_579920 != nil:
    section.add "callback", valid_579920
  var valid_579921 = query.getOrDefault("fields")
  valid_579921 = validateParameter(valid_579921, JString, required = false,
                                 default = nil)
  if valid_579921 != nil:
    section.add "fields", valid_579921
  var valid_579922 = query.getOrDefault("access_token")
  valid_579922 = validateParameter(valid_579922, JString, required = false,
                                 default = nil)
  if valid_579922 != nil:
    section.add "access_token", valid_579922
  var valid_579923 = query.getOrDefault("upload_protocol")
  valid_579923 = validateParameter(valid_579923, JString, required = false,
                                 default = nil)
  if valid_579923 != nil:
    section.add "upload_protocol", valid_579923
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

proc call*(call_579925: Call_AccesscontextmanagerAccessPoliciesCreate_579910;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an `AccessPolicy`. Fails if this organization already has a
  ## `AccessPolicy`. The longrunning Operation will have a successful status
  ## once the `AccessPolicy` has propagated to long-lasting storage.
  ## Syntactic and basic semantic errors will be returned in `metadata` as a
  ## BadRequest proto.
  ## 
  let valid = call_579925.validator(path, query, header, formData, body)
  let scheme = call_579925.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579925.url(scheme.get, call_579925.host, call_579925.base,
                         call_579925.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579925, url, valid)

proc call*(call_579926: Call_AccesscontextmanagerAccessPoliciesCreate_579910;
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
  var query_579927 = newJObject()
  var body_579928 = newJObject()
  add(query_579927, "key", newJString(key))
  add(query_579927, "prettyPrint", newJBool(prettyPrint))
  add(query_579927, "oauth_token", newJString(oauthToken))
  add(query_579927, "$.xgafv", newJString(Xgafv))
  add(query_579927, "alt", newJString(alt))
  add(query_579927, "uploadType", newJString(uploadType))
  add(query_579927, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579928 = body
  add(query_579927, "callback", newJString(callback))
  add(query_579927, "fields", newJString(fields))
  add(query_579927, "access_token", newJString(accessToken))
  add(query_579927, "upload_protocol", newJString(uploadProtocol))
  result = call_579926.call(nil, query_579927, nil, nil, body_579928)

var accesscontextmanagerAccessPoliciesCreate* = Call_AccesscontextmanagerAccessPoliciesCreate_579910(
    name: "accesscontextmanagerAccessPoliciesCreate", meth: HttpMethod.HttpPost,
    host: "accesscontextmanager.googleapis.com", route: "/v1beta/accessPolicies",
    validator: validate_AccesscontextmanagerAccessPoliciesCreate_579911,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesCreate_579912,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesList_579635 = ref object of OpenApiRestCall_579364
proc url_AccesscontextmanagerAccessPoliciesList_579637(protocol: Scheme;
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

proc validate_AccesscontextmanagerAccessPoliciesList_579636(path: JsonNode;
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
  var valid_579769 = query.getOrDefault("parent")
  valid_579769 = validateParameter(valid_579769, JString, required = false,
                                 default = nil)
  if valid_579769 != nil:
    section.add "parent", valid_579769
  var valid_579770 = query.getOrDefault("quotaUser")
  valid_579770 = validateParameter(valid_579770, JString, required = false,
                                 default = nil)
  if valid_579770 != nil:
    section.add "quotaUser", valid_579770
  var valid_579771 = query.getOrDefault("pageToken")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = nil)
  if valid_579771 != nil:
    section.add "pageToken", valid_579771
  var valid_579772 = query.getOrDefault("callback")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = nil)
  if valid_579772 != nil:
    section.add "callback", valid_579772
  var valid_579773 = query.getOrDefault("fields")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "fields", valid_579773
  var valid_579774 = query.getOrDefault("access_token")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = nil)
  if valid_579774 != nil:
    section.add "access_token", valid_579774
  var valid_579775 = query.getOrDefault("upload_protocol")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = nil)
  if valid_579775 != nil:
    section.add "upload_protocol", valid_579775
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579798: Call_AccesscontextmanagerAccessPoliciesList_579635;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all AccessPolicies under a
  ## container.
  ## 
  let valid = call_579798.validator(path, query, header, formData, body)
  let scheme = call_579798.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579798.url(scheme.get, call_579798.host, call_579798.base,
                         call_579798.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579798, url, valid)

proc call*(call_579869: Call_AccesscontextmanagerAccessPoliciesList_579635;
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
  var query_579870 = newJObject()
  add(query_579870, "key", newJString(key))
  add(query_579870, "prettyPrint", newJBool(prettyPrint))
  add(query_579870, "oauth_token", newJString(oauthToken))
  add(query_579870, "$.xgafv", newJString(Xgafv))
  add(query_579870, "pageSize", newJInt(pageSize))
  add(query_579870, "alt", newJString(alt))
  add(query_579870, "uploadType", newJString(uploadType))
  add(query_579870, "parent", newJString(parent))
  add(query_579870, "quotaUser", newJString(quotaUser))
  add(query_579870, "pageToken", newJString(pageToken))
  add(query_579870, "callback", newJString(callback))
  add(query_579870, "fields", newJString(fields))
  add(query_579870, "access_token", newJString(accessToken))
  add(query_579870, "upload_protocol", newJString(uploadProtocol))
  result = call_579869.call(nil, query_579870, nil, nil, nil)

var accesscontextmanagerAccessPoliciesList* = Call_AccesscontextmanagerAccessPoliciesList_579635(
    name: "accesscontextmanagerAccessPoliciesList", meth: HttpMethod.HttpGet,
    host: "accesscontextmanager.googleapis.com", route: "/v1beta/accessPolicies",
    validator: validate_AccesscontextmanagerAccessPoliciesList_579636, base: "/",
    url: url_AccesscontextmanagerAccessPoliciesList_579637,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesServicePerimetersGet_579929 = ref object of OpenApiRestCall_579364
proc url_AccesscontextmanagerAccessPoliciesServicePerimetersGet_579931(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesServicePerimetersGet_579930(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get an Service Perimeter by resource
  ## name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name for the Service Perimeter.
  ## 
  ## Format:
  ## `accessPolicies/{policy_id}/servicePerimeters/{service_perimeters_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579946 = path.getOrDefault("name")
  valid_579946 = validateParameter(valid_579946, JString, required = true,
                                 default = nil)
  if valid_579946 != nil:
    section.add "name", valid_579946
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
  var valid_579947 = query.getOrDefault("key")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "key", valid_579947
  var valid_579948 = query.getOrDefault("prettyPrint")
  valid_579948 = validateParameter(valid_579948, JBool, required = false,
                                 default = newJBool(true))
  if valid_579948 != nil:
    section.add "prettyPrint", valid_579948
  var valid_579949 = query.getOrDefault("oauth_token")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "oauth_token", valid_579949
  var valid_579950 = query.getOrDefault("$.xgafv")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = newJString("1"))
  if valid_579950 != nil:
    section.add "$.xgafv", valid_579950
  var valid_579951 = query.getOrDefault("alt")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = newJString("json"))
  if valid_579951 != nil:
    section.add "alt", valid_579951
  var valid_579952 = query.getOrDefault("uploadType")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "uploadType", valid_579952
  var valid_579953 = query.getOrDefault("quotaUser")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "quotaUser", valid_579953
  var valid_579954 = query.getOrDefault("callback")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "callback", valid_579954
  var valid_579955 = query.getOrDefault("accessLevelFormat")
  valid_579955 = validateParameter(valid_579955, JString, required = false, default = newJString(
      "LEVEL_FORMAT_UNSPECIFIED"))
  if valid_579955 != nil:
    section.add "accessLevelFormat", valid_579955
  var valid_579956 = query.getOrDefault("fields")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "fields", valid_579956
  var valid_579957 = query.getOrDefault("access_token")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "access_token", valid_579957
  var valid_579958 = query.getOrDefault("upload_protocol")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "upload_protocol", valid_579958
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579959: Call_AccesscontextmanagerAccessPoliciesServicePerimetersGet_579929;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an Service Perimeter by resource
  ## name.
  ## 
  let valid = call_579959.validator(path, query, header, formData, body)
  let scheme = call_579959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579959.url(scheme.get, call_579959.host, call_579959.base,
                         call_579959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579959, url, valid)

proc call*(call_579960: Call_AccesscontextmanagerAccessPoliciesServicePerimetersGet_579929;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          accessLevelFormat: string = "LEVEL_FORMAT_UNSPECIFIED";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## accesscontextmanagerAccessPoliciesServicePerimetersGet
  ## Get an Service Perimeter by resource
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
  ##       : Required. Resource name for the Service Perimeter.
  ## 
  ## Format:
  ## `accessPolicies/{policy_id}/servicePerimeters/{service_perimeters_id}`
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
  var path_579961 = newJObject()
  var query_579962 = newJObject()
  add(query_579962, "key", newJString(key))
  add(query_579962, "prettyPrint", newJBool(prettyPrint))
  add(query_579962, "oauth_token", newJString(oauthToken))
  add(query_579962, "$.xgafv", newJString(Xgafv))
  add(query_579962, "alt", newJString(alt))
  add(query_579962, "uploadType", newJString(uploadType))
  add(query_579962, "quotaUser", newJString(quotaUser))
  add(path_579961, "name", newJString(name))
  add(query_579962, "callback", newJString(callback))
  add(query_579962, "accessLevelFormat", newJString(accessLevelFormat))
  add(query_579962, "fields", newJString(fields))
  add(query_579962, "access_token", newJString(accessToken))
  add(query_579962, "upload_protocol", newJString(uploadProtocol))
  result = call_579960.call(path_579961, query_579962, nil, nil, nil)

var accesscontextmanagerAccessPoliciesServicePerimetersGet* = Call_AccesscontextmanagerAccessPoliciesServicePerimetersGet_579929(
    name: "accesscontextmanagerAccessPoliciesServicePerimetersGet",
    meth: HttpMethod.HttpGet, host: "accesscontextmanager.googleapis.com",
    route: "/v1beta/{name}",
    validator: validate_AccesscontextmanagerAccessPoliciesServicePerimetersGet_579930,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesServicePerimetersGet_579931,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesServicePerimetersPatch_579982 = ref object of OpenApiRestCall_579364
proc url_AccesscontextmanagerAccessPoliciesServicePerimetersPatch_579984(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesServicePerimetersPatch_579983(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update an Service Perimeter. The
  ## longrunning operation from this RPC will have a successful status once the
  ## changes to the Service Perimeter have
  ## propagated to long-lasting storage. Service Perimeter containing
  ## errors will result in an error response for the first error encountered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name for the ServicePerimeter.  The `short_name`
  ## component must begin with a letter and only include alphanumeric and '_'.
  ## Format: `accessPolicies/{policy_id}/servicePerimeters/{short_name}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579985 = path.getOrDefault("name")
  valid_579985 = validateParameter(valid_579985, JString, required = true,
                                 default = nil)
  if valid_579985 != nil:
    section.add "name", valid_579985
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
  var valid_579986 = query.getOrDefault("key")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "key", valid_579986
  var valid_579987 = query.getOrDefault("prettyPrint")
  valid_579987 = validateParameter(valid_579987, JBool, required = false,
                                 default = newJBool(true))
  if valid_579987 != nil:
    section.add "prettyPrint", valid_579987
  var valid_579988 = query.getOrDefault("oauth_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "oauth_token", valid_579988
  var valid_579989 = query.getOrDefault("$.xgafv")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = newJString("1"))
  if valid_579989 != nil:
    section.add "$.xgafv", valid_579989
  var valid_579990 = query.getOrDefault("alt")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = newJString("json"))
  if valid_579990 != nil:
    section.add "alt", valid_579990
  var valid_579991 = query.getOrDefault("uploadType")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "uploadType", valid_579991
  var valid_579992 = query.getOrDefault("quotaUser")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "quotaUser", valid_579992
  var valid_579993 = query.getOrDefault("updateMask")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "updateMask", valid_579993
  var valid_579994 = query.getOrDefault("callback")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "callback", valid_579994
  var valid_579995 = query.getOrDefault("fields")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "fields", valid_579995
  var valid_579996 = query.getOrDefault("access_token")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "access_token", valid_579996
  var valid_579997 = query.getOrDefault("upload_protocol")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "upload_protocol", valid_579997
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

proc call*(call_579999: Call_AccesscontextmanagerAccessPoliciesServicePerimetersPatch_579982;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an Service Perimeter. The
  ## longrunning operation from this RPC will have a successful status once the
  ## changes to the Service Perimeter have
  ## propagated to long-lasting storage. Service Perimeter containing
  ## errors will result in an error response for the first error encountered.
  ## 
  let valid = call_579999.validator(path, query, header, formData, body)
  let scheme = call_579999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579999.url(scheme.get, call_579999.host, call_579999.base,
                         call_579999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579999, url, valid)

proc call*(call_580000: Call_AccesscontextmanagerAccessPoliciesServicePerimetersPatch_579982;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## accesscontextmanagerAccessPoliciesServicePerimetersPatch
  ## Update an Service Perimeter. The
  ## longrunning operation from this RPC will have a successful status once the
  ## changes to the Service Perimeter have
  ## propagated to long-lasting storage. Service Perimeter containing
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
  ##       : Required. Resource name for the ServicePerimeter.  The `short_name`
  ## component must begin with a letter and only include alphanumeric and '_'.
  ## Format: `accessPolicies/{policy_id}/servicePerimeters/{short_name}`
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
  var path_580001 = newJObject()
  var query_580002 = newJObject()
  var body_580003 = newJObject()
  add(query_580002, "key", newJString(key))
  add(query_580002, "prettyPrint", newJBool(prettyPrint))
  add(query_580002, "oauth_token", newJString(oauthToken))
  add(query_580002, "$.xgafv", newJString(Xgafv))
  add(query_580002, "alt", newJString(alt))
  add(query_580002, "uploadType", newJString(uploadType))
  add(query_580002, "quotaUser", newJString(quotaUser))
  add(path_580001, "name", newJString(name))
  add(query_580002, "updateMask", newJString(updateMask))
  if body != nil:
    body_580003 = body
  add(query_580002, "callback", newJString(callback))
  add(query_580002, "fields", newJString(fields))
  add(query_580002, "access_token", newJString(accessToken))
  add(query_580002, "upload_protocol", newJString(uploadProtocol))
  result = call_580000.call(path_580001, query_580002, nil, nil, body_580003)

var accesscontextmanagerAccessPoliciesServicePerimetersPatch* = Call_AccesscontextmanagerAccessPoliciesServicePerimetersPatch_579982(
    name: "accesscontextmanagerAccessPoliciesServicePerimetersPatch",
    meth: HttpMethod.HttpPatch, host: "accesscontextmanager.googleapis.com",
    route: "/v1beta/{name}", validator: validate_AccesscontextmanagerAccessPoliciesServicePerimetersPatch_579983,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesServicePerimetersPatch_579984,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesServicePerimetersDelete_579963 = ref object of OpenApiRestCall_579364
proc url_AccesscontextmanagerAccessPoliciesServicePerimetersDelete_579965(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesServicePerimetersDelete_579964(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Delete an Service Perimeter by resource
  ## name. The longrunning operation from this RPC will have a successful status
  ## once the Service Perimeter has been
  ## removed from long-lasting storage.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Resource name for the Service Perimeter.
  ## 
  ## Format:
  ## `accessPolicies/{policy_id}/servicePerimeters/{service_perimeter_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579966 = path.getOrDefault("name")
  valid_579966 = validateParameter(valid_579966, JString, required = true,
                                 default = nil)
  if valid_579966 != nil:
    section.add "name", valid_579966
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
  var valid_579967 = query.getOrDefault("key")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "key", valid_579967
  var valid_579968 = query.getOrDefault("prettyPrint")
  valid_579968 = validateParameter(valid_579968, JBool, required = false,
                                 default = newJBool(true))
  if valid_579968 != nil:
    section.add "prettyPrint", valid_579968
  var valid_579969 = query.getOrDefault("oauth_token")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "oauth_token", valid_579969
  var valid_579970 = query.getOrDefault("$.xgafv")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = newJString("1"))
  if valid_579970 != nil:
    section.add "$.xgafv", valid_579970
  var valid_579971 = query.getOrDefault("alt")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = newJString("json"))
  if valid_579971 != nil:
    section.add "alt", valid_579971
  var valid_579972 = query.getOrDefault("uploadType")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "uploadType", valid_579972
  var valid_579973 = query.getOrDefault("quotaUser")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "quotaUser", valid_579973
  var valid_579974 = query.getOrDefault("callback")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "callback", valid_579974
  var valid_579975 = query.getOrDefault("fields")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "fields", valid_579975
  var valid_579976 = query.getOrDefault("access_token")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "access_token", valid_579976
  var valid_579977 = query.getOrDefault("upload_protocol")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "upload_protocol", valid_579977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579978: Call_AccesscontextmanagerAccessPoliciesServicePerimetersDelete_579963;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an Service Perimeter by resource
  ## name. The longrunning operation from this RPC will have a successful status
  ## once the Service Perimeter has been
  ## removed from long-lasting storage.
  ## 
  let valid = call_579978.validator(path, query, header, formData, body)
  let scheme = call_579978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579978.url(scheme.get, call_579978.host, call_579978.base,
                         call_579978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579978, url, valid)

proc call*(call_579979: Call_AccesscontextmanagerAccessPoliciesServicePerimetersDelete_579963;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## accesscontextmanagerAccessPoliciesServicePerimetersDelete
  ## Delete an Service Perimeter by resource
  ## name. The longrunning operation from this RPC will have a successful status
  ## once the Service Perimeter has been
  ## removed from long-lasting storage.
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
  ##       : Required. Resource name for the Service Perimeter.
  ## 
  ## Format:
  ## `accessPolicies/{policy_id}/servicePerimeters/{service_perimeter_id}`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579980 = newJObject()
  var query_579981 = newJObject()
  add(query_579981, "key", newJString(key))
  add(query_579981, "prettyPrint", newJBool(prettyPrint))
  add(query_579981, "oauth_token", newJString(oauthToken))
  add(query_579981, "$.xgafv", newJString(Xgafv))
  add(query_579981, "alt", newJString(alt))
  add(query_579981, "uploadType", newJString(uploadType))
  add(query_579981, "quotaUser", newJString(quotaUser))
  add(path_579980, "name", newJString(name))
  add(query_579981, "callback", newJString(callback))
  add(query_579981, "fields", newJString(fields))
  add(query_579981, "access_token", newJString(accessToken))
  add(query_579981, "upload_protocol", newJString(uploadProtocol))
  result = call_579979.call(path_579980, query_579981, nil, nil, nil)

var accesscontextmanagerAccessPoliciesServicePerimetersDelete* = Call_AccesscontextmanagerAccessPoliciesServicePerimetersDelete_579963(
    name: "accesscontextmanagerAccessPoliciesServicePerimetersDelete",
    meth: HttpMethod.HttpDelete, host: "accesscontextmanager.googleapis.com",
    route: "/v1beta/{name}", validator: validate_AccesscontextmanagerAccessPoliciesServicePerimetersDelete_579964,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesServicePerimetersDelete_579965,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_580026 = ref object of OpenApiRestCall_579364
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_580028(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_580027(
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
  var valid_580029 = path.getOrDefault("parent")
  valid_580029 = validateParameter(valid_580029, JString, required = true,
                                 default = nil)
  if valid_580029 != nil:
    section.add "parent", valid_580029
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
  var valid_580030 = query.getOrDefault("key")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "key", valid_580030
  var valid_580031 = query.getOrDefault("prettyPrint")
  valid_580031 = validateParameter(valid_580031, JBool, required = false,
                                 default = newJBool(true))
  if valid_580031 != nil:
    section.add "prettyPrint", valid_580031
  var valid_580032 = query.getOrDefault("oauth_token")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "oauth_token", valid_580032
  var valid_580033 = query.getOrDefault("$.xgafv")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = newJString("1"))
  if valid_580033 != nil:
    section.add "$.xgafv", valid_580033
  var valid_580034 = query.getOrDefault("alt")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("json"))
  if valid_580034 != nil:
    section.add "alt", valid_580034
  var valid_580035 = query.getOrDefault("uploadType")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "uploadType", valid_580035
  var valid_580036 = query.getOrDefault("quotaUser")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "quotaUser", valid_580036
  var valid_580037 = query.getOrDefault("callback")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "callback", valid_580037
  var valid_580038 = query.getOrDefault("fields")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "fields", valid_580038
  var valid_580039 = query.getOrDefault("access_token")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "access_token", valid_580039
  var valid_580040 = query.getOrDefault("upload_protocol")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "upload_protocol", valid_580040
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

proc call*(call_580042: Call_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_580026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an Access Level. The longrunning
  ## operation from this RPC will have a successful status once the Access
  ## Level has
  ## propagated to long-lasting storage. Access Levels containing
  ## errors will result in an error response for the first error encountered.
  ## 
  let valid = call_580042.validator(path, query, header, formData, body)
  let scheme = call_580042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580042.url(scheme.get, call_580042.host, call_580042.base,
                         call_580042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580042, url, valid)

proc call*(call_580043: Call_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_580026;
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
  var path_580044 = newJObject()
  var query_580045 = newJObject()
  var body_580046 = newJObject()
  add(query_580045, "key", newJString(key))
  add(query_580045, "prettyPrint", newJBool(prettyPrint))
  add(query_580045, "oauth_token", newJString(oauthToken))
  add(query_580045, "$.xgafv", newJString(Xgafv))
  add(query_580045, "alt", newJString(alt))
  add(query_580045, "uploadType", newJString(uploadType))
  add(query_580045, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580046 = body
  add(query_580045, "callback", newJString(callback))
  add(path_580044, "parent", newJString(parent))
  add(query_580045, "fields", newJString(fields))
  add(query_580045, "access_token", newJString(accessToken))
  add(query_580045, "upload_protocol", newJString(uploadProtocol))
  result = call_580043.call(path_580044, query_580045, nil, nil, body_580046)

var accesscontextmanagerAccessPoliciesAccessLevelsCreate* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_580026(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsCreate",
    meth: HttpMethod.HttpPost, host: "accesscontextmanager.googleapis.com",
    route: "/v1beta/{parent}/accessLevels",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_580027,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsCreate_580028,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesAccessLevelsList_580004 = ref object of OpenApiRestCall_579364
proc url_AccesscontextmanagerAccessPoliciesAccessLevelsList_580006(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesAccessLevelsList_580005(
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
  var valid_580007 = path.getOrDefault("parent")
  valid_580007 = validateParameter(valid_580007, JString, required = true,
                                 default = nil)
  if valid_580007 != nil:
    section.add "parent", valid_580007
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
  var valid_580008 = query.getOrDefault("key")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "key", valid_580008
  var valid_580009 = query.getOrDefault("prettyPrint")
  valid_580009 = validateParameter(valid_580009, JBool, required = false,
                                 default = newJBool(true))
  if valid_580009 != nil:
    section.add "prettyPrint", valid_580009
  var valid_580010 = query.getOrDefault("oauth_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "oauth_token", valid_580010
  var valid_580011 = query.getOrDefault("$.xgafv")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("1"))
  if valid_580011 != nil:
    section.add "$.xgafv", valid_580011
  var valid_580012 = query.getOrDefault("pageSize")
  valid_580012 = validateParameter(valid_580012, JInt, required = false, default = nil)
  if valid_580012 != nil:
    section.add "pageSize", valid_580012
  var valid_580013 = query.getOrDefault("alt")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = newJString("json"))
  if valid_580013 != nil:
    section.add "alt", valid_580013
  var valid_580014 = query.getOrDefault("uploadType")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "uploadType", valid_580014
  var valid_580015 = query.getOrDefault("quotaUser")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "quotaUser", valid_580015
  var valid_580016 = query.getOrDefault("pageToken")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "pageToken", valid_580016
  var valid_580017 = query.getOrDefault("callback")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "callback", valid_580017
  var valid_580018 = query.getOrDefault("accessLevelFormat")
  valid_580018 = validateParameter(valid_580018, JString, required = false, default = newJString(
      "LEVEL_FORMAT_UNSPECIFIED"))
  if valid_580018 != nil:
    section.add "accessLevelFormat", valid_580018
  var valid_580019 = query.getOrDefault("fields")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "fields", valid_580019
  var valid_580020 = query.getOrDefault("access_token")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "access_token", valid_580020
  var valid_580021 = query.getOrDefault("upload_protocol")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "upload_protocol", valid_580021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580022: Call_AccesscontextmanagerAccessPoliciesAccessLevelsList_580004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all Access Levels for an access
  ## policy.
  ## 
  let valid = call_580022.validator(path, query, header, formData, body)
  let scheme = call_580022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580022.url(scheme.get, call_580022.host, call_580022.base,
                         call_580022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580022, url, valid)

proc call*(call_580023: Call_AccesscontextmanagerAccessPoliciesAccessLevelsList_580004;
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
  var path_580024 = newJObject()
  var query_580025 = newJObject()
  add(query_580025, "key", newJString(key))
  add(query_580025, "prettyPrint", newJBool(prettyPrint))
  add(query_580025, "oauth_token", newJString(oauthToken))
  add(query_580025, "$.xgafv", newJString(Xgafv))
  add(query_580025, "pageSize", newJInt(pageSize))
  add(query_580025, "alt", newJString(alt))
  add(query_580025, "uploadType", newJString(uploadType))
  add(query_580025, "quotaUser", newJString(quotaUser))
  add(query_580025, "pageToken", newJString(pageToken))
  add(query_580025, "callback", newJString(callback))
  add(path_580024, "parent", newJString(parent))
  add(query_580025, "accessLevelFormat", newJString(accessLevelFormat))
  add(query_580025, "fields", newJString(fields))
  add(query_580025, "access_token", newJString(accessToken))
  add(query_580025, "upload_protocol", newJString(uploadProtocol))
  result = call_580023.call(path_580024, query_580025, nil, nil, nil)

var accesscontextmanagerAccessPoliciesAccessLevelsList* = Call_AccesscontextmanagerAccessPoliciesAccessLevelsList_580004(
    name: "accesscontextmanagerAccessPoliciesAccessLevelsList",
    meth: HttpMethod.HttpGet, host: "accesscontextmanager.googleapis.com",
    route: "/v1beta/{parent}/accessLevels",
    validator: validate_AccesscontextmanagerAccessPoliciesAccessLevelsList_580005,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesAccessLevelsList_580006,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_580068 = ref object of OpenApiRestCall_579364
proc url_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_580070(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_580069(
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
  var valid_580071 = path.getOrDefault("parent")
  valid_580071 = validateParameter(valid_580071, JString, required = true,
                                 default = nil)
  if valid_580071 != nil:
    section.add "parent", valid_580071
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
  var valid_580072 = query.getOrDefault("key")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "key", valid_580072
  var valid_580073 = query.getOrDefault("prettyPrint")
  valid_580073 = validateParameter(valid_580073, JBool, required = false,
                                 default = newJBool(true))
  if valid_580073 != nil:
    section.add "prettyPrint", valid_580073
  var valid_580074 = query.getOrDefault("oauth_token")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "oauth_token", valid_580074
  var valid_580075 = query.getOrDefault("$.xgafv")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = newJString("1"))
  if valid_580075 != nil:
    section.add "$.xgafv", valid_580075
  var valid_580076 = query.getOrDefault("alt")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("json"))
  if valid_580076 != nil:
    section.add "alt", valid_580076
  var valid_580077 = query.getOrDefault("uploadType")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "uploadType", valid_580077
  var valid_580078 = query.getOrDefault("quotaUser")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "quotaUser", valid_580078
  var valid_580079 = query.getOrDefault("callback")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "callback", valid_580079
  var valid_580080 = query.getOrDefault("fields")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "fields", valid_580080
  var valid_580081 = query.getOrDefault("access_token")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "access_token", valid_580081
  var valid_580082 = query.getOrDefault("upload_protocol")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "upload_protocol", valid_580082
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

proc call*(call_580084: Call_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_580068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an Service Perimeter. The
  ## longrunning operation from this RPC will have a successful status once the
  ## Service Perimeter has
  ## propagated to long-lasting storage. Service Perimeters containing
  ## errors will result in an error response for the first error encountered.
  ## 
  let valid = call_580084.validator(path, query, header, formData, body)
  let scheme = call_580084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580084.url(scheme.get, call_580084.host, call_580084.base,
                         call_580084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580084, url, valid)

proc call*(call_580085: Call_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_580068;
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
  var path_580086 = newJObject()
  var query_580087 = newJObject()
  var body_580088 = newJObject()
  add(query_580087, "key", newJString(key))
  add(query_580087, "prettyPrint", newJBool(prettyPrint))
  add(query_580087, "oauth_token", newJString(oauthToken))
  add(query_580087, "$.xgafv", newJString(Xgafv))
  add(query_580087, "alt", newJString(alt))
  add(query_580087, "uploadType", newJString(uploadType))
  add(query_580087, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580088 = body
  add(query_580087, "callback", newJString(callback))
  add(path_580086, "parent", newJString(parent))
  add(query_580087, "fields", newJString(fields))
  add(query_580087, "access_token", newJString(accessToken))
  add(query_580087, "upload_protocol", newJString(uploadProtocol))
  result = call_580085.call(path_580086, query_580087, nil, nil, body_580088)

var accesscontextmanagerAccessPoliciesServicePerimetersCreate* = Call_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_580068(
    name: "accesscontextmanagerAccessPoliciesServicePerimetersCreate",
    meth: HttpMethod.HttpPost, host: "accesscontextmanager.googleapis.com",
    route: "/v1beta/{parent}/servicePerimeters", validator: validate_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_580069,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesServicePerimetersCreate_580070,
    schemes: {Scheme.Https})
type
  Call_AccesscontextmanagerAccessPoliciesServicePerimetersList_580047 = ref object of OpenApiRestCall_579364
proc url_AccesscontextmanagerAccessPoliciesServicePerimetersList_580049(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_AccesscontextmanagerAccessPoliciesServicePerimetersList_580048(
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
  var valid_580050 = path.getOrDefault("parent")
  valid_580050 = validateParameter(valid_580050, JString, required = true,
                                 default = nil)
  if valid_580050 != nil:
    section.add "parent", valid_580050
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
  var valid_580051 = query.getOrDefault("key")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "key", valid_580051
  var valid_580052 = query.getOrDefault("prettyPrint")
  valid_580052 = validateParameter(valid_580052, JBool, required = false,
                                 default = newJBool(true))
  if valid_580052 != nil:
    section.add "prettyPrint", valid_580052
  var valid_580053 = query.getOrDefault("oauth_token")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "oauth_token", valid_580053
  var valid_580054 = query.getOrDefault("$.xgafv")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = newJString("1"))
  if valid_580054 != nil:
    section.add "$.xgafv", valid_580054
  var valid_580055 = query.getOrDefault("pageSize")
  valid_580055 = validateParameter(valid_580055, JInt, required = false, default = nil)
  if valid_580055 != nil:
    section.add "pageSize", valid_580055
  var valid_580056 = query.getOrDefault("alt")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("json"))
  if valid_580056 != nil:
    section.add "alt", valid_580056
  var valid_580057 = query.getOrDefault("uploadType")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "uploadType", valid_580057
  var valid_580058 = query.getOrDefault("quotaUser")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "quotaUser", valid_580058
  var valid_580059 = query.getOrDefault("pageToken")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "pageToken", valid_580059
  var valid_580060 = query.getOrDefault("callback")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "callback", valid_580060
  var valid_580061 = query.getOrDefault("fields")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "fields", valid_580061
  var valid_580062 = query.getOrDefault("access_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "access_token", valid_580062
  var valid_580063 = query.getOrDefault("upload_protocol")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "upload_protocol", valid_580063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580064: Call_AccesscontextmanagerAccessPoliciesServicePerimetersList_580047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all Service Perimeters for an
  ## access policy.
  ## 
  let valid = call_580064.validator(path, query, header, formData, body)
  let scheme = call_580064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580064.url(scheme.get, call_580064.host, call_580064.base,
                         call_580064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580064, url, valid)

proc call*(call_580065: Call_AccesscontextmanagerAccessPoliciesServicePerimetersList_580047;
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
  var path_580066 = newJObject()
  var query_580067 = newJObject()
  add(query_580067, "key", newJString(key))
  add(query_580067, "prettyPrint", newJBool(prettyPrint))
  add(query_580067, "oauth_token", newJString(oauthToken))
  add(query_580067, "$.xgafv", newJString(Xgafv))
  add(query_580067, "pageSize", newJInt(pageSize))
  add(query_580067, "alt", newJString(alt))
  add(query_580067, "uploadType", newJString(uploadType))
  add(query_580067, "quotaUser", newJString(quotaUser))
  add(query_580067, "pageToken", newJString(pageToken))
  add(query_580067, "callback", newJString(callback))
  add(path_580066, "parent", newJString(parent))
  add(query_580067, "fields", newJString(fields))
  add(query_580067, "access_token", newJString(accessToken))
  add(query_580067, "upload_protocol", newJString(uploadProtocol))
  result = call_580065.call(path_580066, query_580067, nil, nil, nil)

var accesscontextmanagerAccessPoliciesServicePerimetersList* = Call_AccesscontextmanagerAccessPoliciesServicePerimetersList_580047(
    name: "accesscontextmanagerAccessPoliciesServicePerimetersList",
    meth: HttpMethod.HttpGet, host: "accesscontextmanager.googleapis.com",
    route: "/v1beta/{parent}/servicePerimeters", validator: validate_AccesscontextmanagerAccessPoliciesServicePerimetersList_580048,
    base: "/", url: url_AccesscontextmanagerAccessPoliciesServicePerimetersList_580049,
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
