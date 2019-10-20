
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Service User
## version: v1
## termsOfService: (not provided)
## license: (not provided)
## 
## Enables services that service consumers want to use on Google Cloud Platform, lists the available or enabled services, or disables services that service consumers no longer use.
## 
## https://cloud.google.com/service-management/
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  gcpServiceName = "serviceuser"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServiceuserServicesSearch_578619 = ref object of OpenApiRestCall_578348
proc url_ServiceuserServicesSearch_578621(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ServiceuserServicesSearch_578620(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Search available services.
  ## 
  ## When no filter is specified, returns all accessible services. For
  ## authenticated users, also returns all services the calling user has
  ## "servicemanagement.services.bind" permission for.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : Requested size of the next page of data.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token identifying which result to start with; returned by a previous list
  ## call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578733 = query.getOrDefault("key")
  valid_578733 = validateParameter(valid_578733, JString, required = false,
                                 default = nil)
  if valid_578733 != nil:
    section.add "key", valid_578733
  var valid_578747 = query.getOrDefault("pp")
  valid_578747 = validateParameter(valid_578747, JBool, required = false,
                                 default = newJBool(true))
  if valid_578747 != nil:
    section.add "pp", valid_578747
  var valid_578748 = query.getOrDefault("prettyPrint")
  valid_578748 = validateParameter(valid_578748, JBool, required = false,
                                 default = newJBool(true))
  if valid_578748 != nil:
    section.add "prettyPrint", valid_578748
  var valid_578749 = query.getOrDefault("oauth_token")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "oauth_token", valid_578749
  var valid_578750 = query.getOrDefault("$.xgafv")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = newJString("1"))
  if valid_578750 != nil:
    section.add "$.xgafv", valid_578750
  var valid_578751 = query.getOrDefault("bearer_token")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "bearer_token", valid_578751
  var valid_578752 = query.getOrDefault("pageSize")
  valid_578752 = validateParameter(valid_578752, JInt, required = false, default = nil)
  if valid_578752 != nil:
    section.add "pageSize", valid_578752
  var valid_578753 = query.getOrDefault("alt")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = newJString("json"))
  if valid_578753 != nil:
    section.add "alt", valid_578753
  var valid_578754 = query.getOrDefault("uploadType")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "uploadType", valid_578754
  var valid_578755 = query.getOrDefault("quotaUser")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "quotaUser", valid_578755
  var valid_578756 = query.getOrDefault("pageToken")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "pageToken", valid_578756
  var valid_578757 = query.getOrDefault("callback")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "callback", valid_578757
  var valid_578758 = query.getOrDefault("fields")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "fields", valid_578758
  var valid_578759 = query.getOrDefault("access_token")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "access_token", valid_578759
  var valid_578760 = query.getOrDefault("upload_protocol")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "upload_protocol", valid_578760
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578783: Call_ServiceuserServicesSearch_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Search available services.
  ## 
  ## When no filter is specified, returns all accessible services. For
  ## authenticated users, also returns all services the calling user has
  ## "servicemanagement.services.bind" permission for.
  ## 
  let valid = call_578783.validator(path, query, header, formData, body)
  let scheme = call_578783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578783.url(scheme.get, call_578783.host, call_578783.base,
                         call_578783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578783, url, valid)

proc call*(call_578854: Call_ServiceuserServicesSearch_578619; key: string = "";
          pp: bool = true; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; bearerToken: string = ""; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## serviceuserServicesSearch
  ## Search available services.
  ## 
  ## When no filter is specified, returns all accessible services. For
  ## authenticated users, also returns all services the calling user has
  ## "servicemanagement.services.bind" permission for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : Requested size of the next page of data.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token identifying which result to start with; returned by a previous list
  ## call.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578855 = newJObject()
  add(query_578855, "key", newJString(key))
  add(query_578855, "pp", newJBool(pp))
  add(query_578855, "prettyPrint", newJBool(prettyPrint))
  add(query_578855, "oauth_token", newJString(oauthToken))
  add(query_578855, "$.xgafv", newJString(Xgafv))
  add(query_578855, "bearer_token", newJString(bearerToken))
  add(query_578855, "pageSize", newJInt(pageSize))
  add(query_578855, "alt", newJString(alt))
  add(query_578855, "uploadType", newJString(uploadType))
  add(query_578855, "quotaUser", newJString(quotaUser))
  add(query_578855, "pageToken", newJString(pageToken))
  add(query_578855, "callback", newJString(callback))
  add(query_578855, "fields", newJString(fields))
  add(query_578855, "access_token", newJString(accessToken))
  add(query_578855, "upload_protocol", newJString(uploadProtocol))
  result = call_578854.call(nil, query_578855, nil, nil, nil)

var serviceuserServicesSearch* = Call_ServiceuserServicesSearch_578619(
    name: "serviceuserServicesSearch", meth: HttpMethod.HttpGet,
    host: "serviceuser.googleapis.com", route: "/v1/services:search",
    validator: validate_ServiceuserServicesSearch_578620, base: "/",
    url: url_ServiceuserServicesSearch_578621, schemes: {Scheme.Https})
type
  Call_ServiceuserProjectsServicesDisable_578895 = ref object of OpenApiRestCall_578348
proc url_ServiceuserProjectsServicesDisable_578897(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":disable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceuserProjectsServicesDisable_578896(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Disable a service so it can no longer be used with a
  ## project. This prevents unintended usage that may cause unexpected billing
  ## charges or security leaks.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the consumer and the service to disable for that consumer.
  ## 
  ## The Service User implementation accepts the following forms for consumer:
  ## - "project:<project_id>"
  ## 
  ## A valid path would be:
  ## - /v1/projects/my-project/services/servicemanagement.googleapis.com:disable
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578912 = path.getOrDefault("name")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "name", valid_578912
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_578913 = query.getOrDefault("key")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "key", valid_578913
  var valid_578914 = query.getOrDefault("pp")
  valid_578914 = validateParameter(valid_578914, JBool, required = false,
                                 default = newJBool(true))
  if valid_578914 != nil:
    section.add "pp", valid_578914
  var valid_578915 = query.getOrDefault("prettyPrint")
  valid_578915 = validateParameter(valid_578915, JBool, required = false,
                                 default = newJBool(true))
  if valid_578915 != nil:
    section.add "prettyPrint", valid_578915
  var valid_578916 = query.getOrDefault("oauth_token")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "oauth_token", valid_578916
  var valid_578917 = query.getOrDefault("$.xgafv")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = newJString("1"))
  if valid_578917 != nil:
    section.add "$.xgafv", valid_578917
  var valid_578918 = query.getOrDefault("bearer_token")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "bearer_token", valid_578918
  var valid_578919 = query.getOrDefault("alt")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = newJString("json"))
  if valid_578919 != nil:
    section.add "alt", valid_578919
  var valid_578920 = query.getOrDefault("uploadType")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "uploadType", valid_578920
  var valid_578921 = query.getOrDefault("quotaUser")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "quotaUser", valid_578921
  var valid_578922 = query.getOrDefault("callback")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "callback", valid_578922
  var valid_578923 = query.getOrDefault("fields")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "fields", valid_578923
  var valid_578924 = query.getOrDefault("access_token")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "access_token", valid_578924
  var valid_578925 = query.getOrDefault("upload_protocol")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "upload_protocol", valid_578925
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

proc call*(call_578927: Call_ServiceuserProjectsServicesDisable_578895;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disable a service so it can no longer be used with a
  ## project. This prevents unintended usage that may cause unexpected billing
  ## charges or security leaks.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ## 
  let valid = call_578927.validator(path, query, header, formData, body)
  let scheme = call_578927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578927.url(scheme.get, call_578927.host, call_578927.base,
                         call_578927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578927, url, valid)

proc call*(call_578928: Call_ServiceuserProjectsServicesDisable_578895;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## serviceuserProjectsServicesDisable
  ## Disable a service so it can no longer be used with a
  ## project. This prevents unintended usage that may cause unexpected billing
  ## charges or security leaks.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the consumer and the service to disable for that consumer.
  ## 
  ## The Service User implementation accepts the following forms for consumer:
  ## - "project:<project_id>"
  ## 
  ## A valid path would be:
  ## - /v1/projects/my-project/services/servicemanagement.googleapis.com:disable
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578929 = newJObject()
  var query_578930 = newJObject()
  var body_578931 = newJObject()
  add(query_578930, "key", newJString(key))
  add(query_578930, "pp", newJBool(pp))
  add(query_578930, "prettyPrint", newJBool(prettyPrint))
  add(query_578930, "oauth_token", newJString(oauthToken))
  add(query_578930, "$.xgafv", newJString(Xgafv))
  add(query_578930, "bearer_token", newJString(bearerToken))
  add(query_578930, "alt", newJString(alt))
  add(query_578930, "uploadType", newJString(uploadType))
  add(query_578930, "quotaUser", newJString(quotaUser))
  add(path_578929, "name", newJString(name))
  if body != nil:
    body_578931 = body
  add(query_578930, "callback", newJString(callback))
  add(query_578930, "fields", newJString(fields))
  add(query_578930, "access_token", newJString(accessToken))
  add(query_578930, "upload_protocol", newJString(uploadProtocol))
  result = call_578928.call(path_578929, query_578930, nil, nil, body_578931)

var serviceuserProjectsServicesDisable* = Call_ServiceuserProjectsServicesDisable_578895(
    name: "serviceuserProjectsServicesDisable", meth: HttpMethod.HttpPost,
    host: "serviceuser.googleapis.com", route: "/v1/{name}:disable",
    validator: validate_ServiceuserProjectsServicesDisable_578896, base: "/",
    url: url_ServiceuserProjectsServicesDisable_578897, schemes: {Scheme.Https})
type
  Call_ServiceuserProjectsServicesEnable_578932 = ref object of OpenApiRestCall_578348
proc url_ServiceuserProjectsServicesEnable_578934(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":enable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceuserProjectsServicesEnable_578933(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enable a service so it can be used with a project.
  ## See [Cloud Auth Guide](https://cloud.google.com/docs/authentication) for
  ## more information.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the consumer and the service to enable for that consumer.
  ## 
  ## A valid path would be:
  ## - /v1/projects/my-project/services/servicemanagement.googleapis.com:enable
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578935 = path.getOrDefault("name")
  valid_578935 = validateParameter(valid_578935, JString, required = true,
                                 default = nil)
  if valid_578935 != nil:
    section.add "name", valid_578935
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_578936 = query.getOrDefault("key")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "key", valid_578936
  var valid_578937 = query.getOrDefault("pp")
  valid_578937 = validateParameter(valid_578937, JBool, required = false,
                                 default = newJBool(true))
  if valid_578937 != nil:
    section.add "pp", valid_578937
  var valid_578938 = query.getOrDefault("prettyPrint")
  valid_578938 = validateParameter(valid_578938, JBool, required = false,
                                 default = newJBool(true))
  if valid_578938 != nil:
    section.add "prettyPrint", valid_578938
  var valid_578939 = query.getOrDefault("oauth_token")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "oauth_token", valid_578939
  var valid_578940 = query.getOrDefault("$.xgafv")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = newJString("1"))
  if valid_578940 != nil:
    section.add "$.xgafv", valid_578940
  var valid_578941 = query.getOrDefault("bearer_token")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "bearer_token", valid_578941
  var valid_578942 = query.getOrDefault("alt")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = newJString("json"))
  if valid_578942 != nil:
    section.add "alt", valid_578942
  var valid_578943 = query.getOrDefault("uploadType")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "uploadType", valid_578943
  var valid_578944 = query.getOrDefault("quotaUser")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "quotaUser", valid_578944
  var valid_578945 = query.getOrDefault("callback")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "callback", valid_578945
  var valid_578946 = query.getOrDefault("fields")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "fields", valid_578946
  var valid_578947 = query.getOrDefault("access_token")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "access_token", valid_578947
  var valid_578948 = query.getOrDefault("upload_protocol")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "upload_protocol", valid_578948
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

proc call*(call_578950: Call_ServiceuserProjectsServicesEnable_578932;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enable a service so it can be used with a project.
  ## See [Cloud Auth Guide](https://cloud.google.com/docs/authentication) for
  ## more information.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ## 
  let valid = call_578950.validator(path, query, header, formData, body)
  let scheme = call_578950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578950.url(scheme.get, call_578950.host, call_578950.base,
                         call_578950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578950, url, valid)

proc call*(call_578951: Call_ServiceuserProjectsServicesEnable_578932;
          name: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## serviceuserProjectsServicesEnable
  ## Enable a service so it can be used with a project.
  ## See [Cloud Auth Guide](https://cloud.google.com/docs/authentication) for
  ## more information.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the consumer and the service to enable for that consumer.
  ## 
  ## A valid path would be:
  ## - /v1/projects/my-project/services/servicemanagement.googleapis.com:enable
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578952 = newJObject()
  var query_578953 = newJObject()
  var body_578954 = newJObject()
  add(query_578953, "key", newJString(key))
  add(query_578953, "pp", newJBool(pp))
  add(query_578953, "prettyPrint", newJBool(prettyPrint))
  add(query_578953, "oauth_token", newJString(oauthToken))
  add(query_578953, "$.xgafv", newJString(Xgafv))
  add(query_578953, "bearer_token", newJString(bearerToken))
  add(query_578953, "alt", newJString(alt))
  add(query_578953, "uploadType", newJString(uploadType))
  add(query_578953, "quotaUser", newJString(quotaUser))
  add(path_578952, "name", newJString(name))
  if body != nil:
    body_578954 = body
  add(query_578953, "callback", newJString(callback))
  add(query_578953, "fields", newJString(fields))
  add(query_578953, "access_token", newJString(accessToken))
  add(query_578953, "upload_protocol", newJString(uploadProtocol))
  result = call_578951.call(path_578952, query_578953, nil, nil, body_578954)

var serviceuserProjectsServicesEnable* = Call_ServiceuserProjectsServicesEnable_578932(
    name: "serviceuserProjectsServicesEnable", meth: HttpMethod.HttpPost,
    host: "serviceuser.googleapis.com", route: "/v1/{name}:enable",
    validator: validate_ServiceuserProjectsServicesEnable_578933, base: "/",
    url: url_ServiceuserProjectsServicesEnable_578934, schemes: {Scheme.Https})
type
  Call_ServiceuserProjectsServicesList_578955 = ref object of OpenApiRestCall_578348
proc url_ServiceuserProjectsServicesList_578957(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceuserProjectsServicesList_578956(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List enabled services for the specified consumer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : List enabled services for the specified parent.
  ## 
  ## An example valid parent would be:
  ## - projects/my-project
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_578958 = path.getOrDefault("parent")
  valid_578958 = validateParameter(valid_578958, JString, required = true,
                                 default = nil)
  if valid_578958 != nil:
    section.add "parent", valid_578958
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  ##   pageSize: JInt
  ##           : Requested size of the next page of data.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token identifying which result to start with; returned by a previous list
  ## call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578959 = query.getOrDefault("key")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "key", valid_578959
  var valid_578960 = query.getOrDefault("pp")
  valid_578960 = validateParameter(valid_578960, JBool, required = false,
                                 default = newJBool(true))
  if valid_578960 != nil:
    section.add "pp", valid_578960
  var valid_578961 = query.getOrDefault("prettyPrint")
  valid_578961 = validateParameter(valid_578961, JBool, required = false,
                                 default = newJBool(true))
  if valid_578961 != nil:
    section.add "prettyPrint", valid_578961
  var valid_578962 = query.getOrDefault("oauth_token")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "oauth_token", valid_578962
  var valid_578963 = query.getOrDefault("$.xgafv")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = newJString("1"))
  if valid_578963 != nil:
    section.add "$.xgafv", valid_578963
  var valid_578964 = query.getOrDefault("bearer_token")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "bearer_token", valid_578964
  var valid_578965 = query.getOrDefault("pageSize")
  valid_578965 = validateParameter(valid_578965, JInt, required = false, default = nil)
  if valid_578965 != nil:
    section.add "pageSize", valid_578965
  var valid_578966 = query.getOrDefault("alt")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = newJString("json"))
  if valid_578966 != nil:
    section.add "alt", valid_578966
  var valid_578967 = query.getOrDefault("uploadType")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "uploadType", valid_578967
  var valid_578968 = query.getOrDefault("quotaUser")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "quotaUser", valid_578968
  var valid_578969 = query.getOrDefault("pageToken")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "pageToken", valid_578969
  var valid_578970 = query.getOrDefault("callback")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "callback", valid_578970
  var valid_578971 = query.getOrDefault("fields")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "fields", valid_578971
  var valid_578972 = query.getOrDefault("access_token")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "access_token", valid_578972
  var valid_578973 = query.getOrDefault("upload_protocol")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "upload_protocol", valid_578973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578974: Call_ServiceuserProjectsServicesList_578955;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List enabled services for the specified consumer.
  ## 
  let valid = call_578974.validator(path, query, header, formData, body)
  let scheme = call_578974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578974.url(scheme.get, call_578974.host, call_578974.base,
                         call_578974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578974, url, valid)

proc call*(call_578975: Call_ServiceuserProjectsServicesList_578955;
          parent: string; key: string = ""; pp: bool = true; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; bearerToken: string = "";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## serviceuserProjectsServicesList
  ## List enabled services for the specified consumer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  ##   pageSize: int
  ##           : Requested size of the next page of data.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token identifying which result to start with; returned by a previous list
  ## call.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : List enabled services for the specified parent.
  ## 
  ## An example valid parent would be:
  ## - projects/my-project
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578976 = newJObject()
  var query_578977 = newJObject()
  add(query_578977, "key", newJString(key))
  add(query_578977, "pp", newJBool(pp))
  add(query_578977, "prettyPrint", newJBool(prettyPrint))
  add(query_578977, "oauth_token", newJString(oauthToken))
  add(query_578977, "$.xgafv", newJString(Xgafv))
  add(query_578977, "bearer_token", newJString(bearerToken))
  add(query_578977, "pageSize", newJInt(pageSize))
  add(query_578977, "alt", newJString(alt))
  add(query_578977, "uploadType", newJString(uploadType))
  add(query_578977, "quotaUser", newJString(quotaUser))
  add(query_578977, "pageToken", newJString(pageToken))
  add(query_578977, "callback", newJString(callback))
  add(path_578976, "parent", newJString(parent))
  add(query_578977, "fields", newJString(fields))
  add(query_578977, "access_token", newJString(accessToken))
  add(query_578977, "upload_protocol", newJString(uploadProtocol))
  result = call_578975.call(path_578976, query_578977, nil, nil, nil)

var serviceuserProjectsServicesList* = Call_ServiceuserProjectsServicesList_578955(
    name: "serviceuserProjectsServicesList", meth: HttpMethod.HttpGet,
    host: "serviceuser.googleapis.com", route: "/v1/{parent}/services",
    validator: validate_ServiceuserProjectsServicesList_578956, base: "/",
    url: url_ServiceuserProjectsServicesList_578957, schemes: {Scheme.Https})
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
