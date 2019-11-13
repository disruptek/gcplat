
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Run
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Deploy and manage user provided container images that scale automatically based on HTTP traffic.
## 
## https://cloud.google.com/run/
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
  gcpServiceName = "run"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RunCustomresourcedefinitionsList_579635 = ref object of OpenApiRestCall_579364
proc url_RunCustomresourcedefinitionsList_579637(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_RunCustomresourcedefinitionsList_579636(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to list custom resource definitions.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : The project ID or project number from which the storages should
  ## be listed.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_579749 = query.getOrDefault("key")
  valid_579749 = validateParameter(valid_579749, JString, required = false,
                                 default = nil)
  if valid_579749 != nil:
    section.add "key", valid_579749
  var valid_579750 = query.getOrDefault("includeUninitialized")
  valid_579750 = validateParameter(valid_579750, JBool, required = false, default = nil)
  if valid_579750 != nil:
    section.add "includeUninitialized", valid_579750
  var valid_579764 = query.getOrDefault("prettyPrint")
  valid_579764 = validateParameter(valid_579764, JBool, required = false,
                                 default = newJBool(true))
  if valid_579764 != nil:
    section.add "prettyPrint", valid_579764
  var valid_579765 = query.getOrDefault("oauth_token")
  valid_579765 = validateParameter(valid_579765, JString, required = false,
                                 default = nil)
  if valid_579765 != nil:
    section.add "oauth_token", valid_579765
  var valid_579766 = query.getOrDefault("fieldSelector")
  valid_579766 = validateParameter(valid_579766, JString, required = false,
                                 default = nil)
  if valid_579766 != nil:
    section.add "fieldSelector", valid_579766
  var valid_579767 = query.getOrDefault("labelSelector")
  valid_579767 = validateParameter(valid_579767, JString, required = false,
                                 default = nil)
  if valid_579767 != nil:
    section.add "labelSelector", valid_579767
  var valid_579768 = query.getOrDefault("$.xgafv")
  valid_579768 = validateParameter(valid_579768, JString, required = false,
                                 default = newJString("1"))
  if valid_579768 != nil:
    section.add "$.xgafv", valid_579768
  var valid_579769 = query.getOrDefault("limit")
  valid_579769 = validateParameter(valid_579769, JInt, required = false, default = nil)
  if valid_579769 != nil:
    section.add "limit", valid_579769
  var valid_579770 = query.getOrDefault("alt")
  valid_579770 = validateParameter(valid_579770, JString, required = false,
                                 default = newJString("json"))
  if valid_579770 != nil:
    section.add "alt", valid_579770
  var valid_579771 = query.getOrDefault("uploadType")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = nil)
  if valid_579771 != nil:
    section.add "uploadType", valid_579771
  var valid_579772 = query.getOrDefault("parent")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = nil)
  if valid_579772 != nil:
    section.add "parent", valid_579772
  var valid_579773 = query.getOrDefault("quotaUser")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "quotaUser", valid_579773
  var valid_579774 = query.getOrDefault("watch")
  valid_579774 = validateParameter(valid_579774, JBool, required = false, default = nil)
  if valid_579774 != nil:
    section.add "watch", valid_579774
  var valid_579775 = query.getOrDefault("callback")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = nil)
  if valid_579775 != nil:
    section.add "callback", valid_579775
  var valid_579776 = query.getOrDefault("resourceVersion")
  valid_579776 = validateParameter(valid_579776, JString, required = false,
                                 default = nil)
  if valid_579776 != nil:
    section.add "resourceVersion", valid_579776
  var valid_579777 = query.getOrDefault("fields")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = nil)
  if valid_579777 != nil:
    section.add "fields", valid_579777
  var valid_579778 = query.getOrDefault("access_token")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "access_token", valid_579778
  var valid_579779 = query.getOrDefault("upload_protocol")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "upload_protocol", valid_579779
  var valid_579780 = query.getOrDefault("continue")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "continue", valid_579780
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579803: Call_RunCustomresourcedefinitionsList_579635;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list custom resource definitions.
  ## 
  let valid = call_579803.validator(path, query, header, formData, body)
  let scheme = call_579803.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579803.url(scheme.get, call_579803.host, call_579803.base,
                         call_579803.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579803, url, valid)

proc call*(call_579874: Call_RunCustomresourcedefinitionsList_579635;
          key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; parent: string = "";
          quotaUser: string = ""; watch: bool = false; callback: string = "";
          resourceVersion: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; `continue`: string = ""): Recallable =
  ## runCustomresourcedefinitionsList
  ## Rpc to list custom resource definitions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : The project ID or project number from which the storages should
  ## be listed.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var query_579875 = newJObject()
  add(query_579875, "key", newJString(key))
  add(query_579875, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579875, "prettyPrint", newJBool(prettyPrint))
  add(query_579875, "oauth_token", newJString(oauthToken))
  add(query_579875, "fieldSelector", newJString(fieldSelector))
  add(query_579875, "labelSelector", newJString(labelSelector))
  add(query_579875, "$.xgafv", newJString(Xgafv))
  add(query_579875, "limit", newJInt(limit))
  add(query_579875, "alt", newJString(alt))
  add(query_579875, "uploadType", newJString(uploadType))
  add(query_579875, "parent", newJString(parent))
  add(query_579875, "quotaUser", newJString(quotaUser))
  add(query_579875, "watch", newJBool(watch))
  add(query_579875, "callback", newJString(callback))
  add(query_579875, "resourceVersion", newJString(resourceVersion))
  add(query_579875, "fields", newJString(fields))
  add(query_579875, "access_token", newJString(accessToken))
  add(query_579875, "upload_protocol", newJString(uploadProtocol))
  add(query_579875, "continue", newJString(`continue`))
  result = call_579874.call(nil, query_579875, nil, nil, nil)

var runCustomresourcedefinitionsList* = Call_RunCustomresourcedefinitionsList_579635(
    name: "runCustomresourcedefinitionsList", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/apiextensions.k8s.io/v1beta1/customresourcedefinitions",
    validator: validate_RunCustomresourcedefinitionsList_579636, base: "/",
    url: url_RunCustomresourcedefinitionsList_579637, schemes: {Scheme.Https})
type
  Call_RunNamespacesCustomresourcedefinitionsGet_579915 = ref object of OpenApiRestCall_579364
proc url_RunNamespacesCustomresourcedefinitionsGet_579917(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/apis/apiextensions.k8s.io/v1beta1/"),
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

proc validate_RunNamespacesCustomresourcedefinitionsGet_579916(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rpc to get information about a CustomResourceDefinition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the CustomResourceDefinition being retrieved. If needed,
  ## replace {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579932 = path.getOrDefault("name")
  valid_579932 = validateParameter(valid_579932, JString, required = true,
                                 default = nil)
  if valid_579932 != nil:
    section.add "name", valid_579932
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
  var valid_579933 = query.getOrDefault("key")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "key", valid_579933
  var valid_579934 = query.getOrDefault("prettyPrint")
  valid_579934 = validateParameter(valid_579934, JBool, required = false,
                                 default = newJBool(true))
  if valid_579934 != nil:
    section.add "prettyPrint", valid_579934
  var valid_579935 = query.getOrDefault("oauth_token")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "oauth_token", valid_579935
  var valid_579936 = query.getOrDefault("$.xgafv")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = newJString("1"))
  if valid_579936 != nil:
    section.add "$.xgafv", valid_579936
  var valid_579937 = query.getOrDefault("alt")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = newJString("json"))
  if valid_579937 != nil:
    section.add "alt", valid_579937
  var valid_579938 = query.getOrDefault("uploadType")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "uploadType", valid_579938
  var valid_579939 = query.getOrDefault("quotaUser")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "quotaUser", valid_579939
  var valid_579940 = query.getOrDefault("callback")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = nil)
  if valid_579940 != nil:
    section.add "callback", valid_579940
  var valid_579941 = query.getOrDefault("fields")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "fields", valid_579941
  var valid_579942 = query.getOrDefault("access_token")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = nil)
  if valid_579942 != nil:
    section.add "access_token", valid_579942
  var valid_579943 = query.getOrDefault("upload_protocol")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "upload_protocol", valid_579943
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579944: Call_RunNamespacesCustomresourcedefinitionsGet_579915;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to get information about a CustomResourceDefinition.
  ## 
  let valid = call_579944.validator(path, query, header, formData, body)
  let scheme = call_579944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579944.url(scheme.get, call_579944.host, call_579944.base,
                         call_579944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579944, url, valid)

proc call*(call_579945: Call_RunNamespacesCustomresourcedefinitionsGet_579915;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runNamespacesCustomresourcedefinitionsGet
  ## Rpc to get information about a CustomResourceDefinition.
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
  ##       : The name of the CustomResourceDefinition being retrieved. If needed,
  ## replace {namespace_id} with the project ID.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579946 = newJObject()
  var query_579947 = newJObject()
  add(query_579947, "key", newJString(key))
  add(query_579947, "prettyPrint", newJBool(prettyPrint))
  add(query_579947, "oauth_token", newJString(oauthToken))
  add(query_579947, "$.xgafv", newJString(Xgafv))
  add(query_579947, "alt", newJString(alt))
  add(query_579947, "uploadType", newJString(uploadType))
  add(query_579947, "quotaUser", newJString(quotaUser))
  add(path_579946, "name", newJString(name))
  add(query_579947, "callback", newJString(callback))
  add(query_579947, "fields", newJString(fields))
  add(query_579947, "access_token", newJString(accessToken))
  add(query_579947, "upload_protocol", newJString(uploadProtocol))
  result = call_579945.call(path_579946, query_579947, nil, nil, nil)

var runNamespacesCustomresourcedefinitionsGet* = Call_RunNamespacesCustomresourcedefinitionsGet_579915(
    name: "runNamespacesCustomresourcedefinitionsGet", meth: HttpMethod.HttpGet,
    host: "run.googleapis.com",
    route: "/apis/apiextensions.k8s.io/v1beta1/{name}",
    validator: validate_RunNamespacesCustomresourcedefinitionsGet_579916,
    base: "/", url: url_RunNamespacesCustomresourcedefinitionsGet_579917,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsCustomresourcedefinitionsGet_579948 = ref object of OpenApiRestCall_579364
proc url_RunProjectsLocationsCustomresourcedefinitionsGet_579950(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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

proc validate_RunProjectsLocationsCustomresourcedefinitionsGet_579949(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Rpc to get information about a CustomResourceDefinition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the CustomResourceDefinition being retrieved. If needed,
  ## replace {namespace_id} with the project ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579951 = path.getOrDefault("name")
  valid_579951 = validateParameter(valid_579951, JString, required = true,
                                 default = nil)
  if valid_579951 != nil:
    section.add "name", valid_579951
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
  var valid_579952 = query.getOrDefault("key")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "key", valid_579952
  var valid_579953 = query.getOrDefault("prettyPrint")
  valid_579953 = validateParameter(valid_579953, JBool, required = false,
                                 default = newJBool(true))
  if valid_579953 != nil:
    section.add "prettyPrint", valid_579953
  var valid_579954 = query.getOrDefault("oauth_token")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "oauth_token", valid_579954
  var valid_579955 = query.getOrDefault("$.xgafv")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = newJString("1"))
  if valid_579955 != nil:
    section.add "$.xgafv", valid_579955
  var valid_579956 = query.getOrDefault("alt")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = newJString("json"))
  if valid_579956 != nil:
    section.add "alt", valid_579956
  var valid_579957 = query.getOrDefault("uploadType")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "uploadType", valid_579957
  var valid_579958 = query.getOrDefault("quotaUser")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "quotaUser", valid_579958
  var valid_579959 = query.getOrDefault("callback")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "callback", valid_579959
  var valid_579960 = query.getOrDefault("fields")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "fields", valid_579960
  var valid_579961 = query.getOrDefault("access_token")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "access_token", valid_579961
  var valid_579962 = query.getOrDefault("upload_protocol")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "upload_protocol", valid_579962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579963: Call_RunProjectsLocationsCustomresourcedefinitionsGet_579948;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to get information about a CustomResourceDefinition.
  ## 
  let valid = call_579963.validator(path, query, header, formData, body)
  let scheme = call_579963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579963.url(scheme.get, call_579963.host, call_579963.base,
                         call_579963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579963, url, valid)

proc call*(call_579964: Call_RunProjectsLocationsCustomresourcedefinitionsGet_579948;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## runProjectsLocationsCustomresourcedefinitionsGet
  ## Rpc to get information about a CustomResourceDefinition.
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
  ##       : The name of the CustomResourceDefinition being retrieved. If needed,
  ## replace {namespace_id} with the project ID.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579965 = newJObject()
  var query_579966 = newJObject()
  add(query_579966, "key", newJString(key))
  add(query_579966, "prettyPrint", newJBool(prettyPrint))
  add(query_579966, "oauth_token", newJString(oauthToken))
  add(query_579966, "$.xgafv", newJString(Xgafv))
  add(query_579966, "alt", newJString(alt))
  add(query_579966, "uploadType", newJString(uploadType))
  add(query_579966, "quotaUser", newJString(quotaUser))
  add(path_579965, "name", newJString(name))
  add(query_579966, "callback", newJString(callback))
  add(query_579966, "fields", newJString(fields))
  add(query_579966, "access_token", newJString(accessToken))
  add(query_579966, "upload_protocol", newJString(uploadProtocol))
  result = call_579964.call(path_579965, query_579966, nil, nil, nil)

var runProjectsLocationsCustomresourcedefinitionsGet* = Call_RunProjectsLocationsCustomresourcedefinitionsGet_579948(
    name: "runProjectsLocationsCustomresourcedefinitionsGet",
    meth: HttpMethod.HttpGet, host: "run.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_RunProjectsLocationsCustomresourcedefinitionsGet_579949,
    base: "/", url: url_RunProjectsLocationsCustomresourcedefinitionsGet_579950,
    schemes: {Scheme.Https})
type
  Call_RunProjectsLocationsCustomresourcedefinitionsList_579967 = ref object of OpenApiRestCall_579364
proc url_RunProjectsLocationsCustomresourcedefinitionsList_579969(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/customresourcedefinitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_RunProjectsLocationsCustomresourcedefinitionsList_579968(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Rpc to list custom resource definitions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project ID or project number from which the storages should
  ## be listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579970 = path.getOrDefault("parent")
  valid_579970 = validateParameter(valid_579970, JString, required = true,
                                 default = nil)
  if valid_579970 != nil:
    section.add "parent", valid_579970
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: JBool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fieldSelector: JString
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: JString
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   limit: JInt
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: JBool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: JString
  ##           : JSONP
  ##   resourceVersion: JString
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: JString
  ##           : Optional encoded string to continue paging.
  section = newJObject()
  var valid_579971 = query.getOrDefault("key")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "key", valid_579971
  var valid_579972 = query.getOrDefault("includeUninitialized")
  valid_579972 = validateParameter(valid_579972, JBool, required = false, default = nil)
  if valid_579972 != nil:
    section.add "includeUninitialized", valid_579972
  var valid_579973 = query.getOrDefault("prettyPrint")
  valid_579973 = validateParameter(valid_579973, JBool, required = false,
                                 default = newJBool(true))
  if valid_579973 != nil:
    section.add "prettyPrint", valid_579973
  var valid_579974 = query.getOrDefault("oauth_token")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "oauth_token", valid_579974
  var valid_579975 = query.getOrDefault("fieldSelector")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "fieldSelector", valid_579975
  var valid_579976 = query.getOrDefault("labelSelector")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "labelSelector", valid_579976
  var valid_579977 = query.getOrDefault("$.xgafv")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = newJString("1"))
  if valid_579977 != nil:
    section.add "$.xgafv", valid_579977
  var valid_579978 = query.getOrDefault("limit")
  valid_579978 = validateParameter(valid_579978, JInt, required = false, default = nil)
  if valid_579978 != nil:
    section.add "limit", valid_579978
  var valid_579979 = query.getOrDefault("alt")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("json"))
  if valid_579979 != nil:
    section.add "alt", valid_579979
  var valid_579980 = query.getOrDefault("uploadType")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "uploadType", valid_579980
  var valid_579981 = query.getOrDefault("quotaUser")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "quotaUser", valid_579981
  var valid_579982 = query.getOrDefault("watch")
  valid_579982 = validateParameter(valid_579982, JBool, required = false, default = nil)
  if valid_579982 != nil:
    section.add "watch", valid_579982
  var valid_579983 = query.getOrDefault("callback")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "callback", valid_579983
  var valid_579984 = query.getOrDefault("resourceVersion")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "resourceVersion", valid_579984
  var valid_579985 = query.getOrDefault("fields")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "fields", valid_579985
  var valid_579986 = query.getOrDefault("access_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "access_token", valid_579986
  var valid_579987 = query.getOrDefault("upload_protocol")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "upload_protocol", valid_579987
  var valid_579988 = query.getOrDefault("continue")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "continue", valid_579988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579989: Call_RunProjectsLocationsCustomresourcedefinitionsList_579967;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rpc to list custom resource definitions.
  ## 
  let valid = call_579989.validator(path, query, header, formData, body)
  let scheme = call_579989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579989.url(scheme.get, call_579989.host, call_579989.base,
                         call_579989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579989, url, valid)

proc call*(call_579990: Call_RunProjectsLocationsCustomresourcedefinitionsList_579967;
          parent: string; key: string = ""; includeUninitialized: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; fieldSelector: string = "";
          labelSelector: string = ""; Xgafv: string = "1"; limit: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          watch: bool = false; callback: string = ""; resourceVersion: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          `continue`: string = ""): Recallable =
  ## runProjectsLocationsCustomresourcedefinitionsList
  ## Rpc to list custom resource definitions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeUninitialized: bool
  ##                       : Not currently used by Cloud Run.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fieldSelector: string
  ##                : Allows to filter resources based on a specific value for a field name.
  ## Send this in a query string format. i.e. 'metadata.name%3Dlorem'.
  ## Not currently used by Cloud Run.
  ##   labelSelector: string
  ##                : Allows to filter resources based on a label. Supported operations are
  ## =, !=, exists, in, and notIn.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   limit: int
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   watch: bool
  ##        : Flag that indicates that the client expects to watch this resource as well.
  ## Not currently used by Cloud Run.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project ID or project number from which the storages should
  ## be listed.
  ##   resourceVersion: string
  ##                  : The baseline resource version from which the list or watch operation should
  ## start. Not currently used by Cloud Run.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   continue: string
  ##           : Optional encoded string to continue paging.
  var path_579991 = newJObject()
  var query_579992 = newJObject()
  add(query_579992, "key", newJString(key))
  add(query_579992, "includeUninitialized", newJBool(includeUninitialized))
  add(query_579992, "prettyPrint", newJBool(prettyPrint))
  add(query_579992, "oauth_token", newJString(oauthToken))
  add(query_579992, "fieldSelector", newJString(fieldSelector))
  add(query_579992, "labelSelector", newJString(labelSelector))
  add(query_579992, "$.xgafv", newJString(Xgafv))
  add(query_579992, "limit", newJInt(limit))
  add(query_579992, "alt", newJString(alt))
  add(query_579992, "uploadType", newJString(uploadType))
  add(query_579992, "quotaUser", newJString(quotaUser))
  add(query_579992, "watch", newJBool(watch))
  add(query_579992, "callback", newJString(callback))
  add(path_579991, "parent", newJString(parent))
  add(query_579992, "resourceVersion", newJString(resourceVersion))
  add(query_579992, "fields", newJString(fields))
  add(query_579992, "access_token", newJString(accessToken))
  add(query_579992, "upload_protocol", newJString(uploadProtocol))
  add(query_579992, "continue", newJString(`continue`))
  result = call_579990.call(path_579991, query_579992, nil, nil, nil)

var runProjectsLocationsCustomresourcedefinitionsList* = Call_RunProjectsLocationsCustomresourcedefinitionsList_579967(
    name: "runProjectsLocationsCustomresourcedefinitionsList",
    meth: HttpMethod.HttpGet, host: "run.googleapis.com",
    route: "/v1beta1/{parent}/customresourcedefinitions",
    validator: validate_RunProjectsLocationsCustomresourcedefinitionsList_579968,
    base: "/", url: url_RunProjectsLocationsCustomresourcedefinitionsList_579969,
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
