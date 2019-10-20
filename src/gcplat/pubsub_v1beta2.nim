
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Pub/Sub
## version: v1beta2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provides reliable, many-to-many, asynchronous messaging between applications.
## 
## 
## https://cloud.google.com/pubsub/docs
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
  gcpServiceName = "pubsub"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PubsubProjectsTopicsCreate_578610 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsCreate_578612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsCreate_578611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the given topic with the given name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the topic. It must have the format
  ## `"projects/{project}/topics/{topic}"`. `{topic}` must start with a letter,
  ## and contain only letters (`[A-Za-z]`), numbers (`[0-9]`), dashes (`-`),
  ## underscores (`_`), periods (`.`), tildes (`~`), plus (`+`) or percent
  ## signs (`%`). It must be between 3 and 255 characters in length, and it
  ## must not start with `"goog"`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578738 = path.getOrDefault("name")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "name", valid_578738
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
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("uploadType")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "uploadType", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("callback")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "callback", valid_578759
  var valid_578760 = query.getOrDefault("fields")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "fields", valid_578760
  var valid_578761 = query.getOrDefault("access_token")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "access_token", valid_578761
  var valid_578762 = query.getOrDefault("upload_protocol")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "upload_protocol", valid_578762
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

proc call*(call_578786: Call_PubsubProjectsTopicsCreate_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the given topic with the given name.
  ## 
  let valid = call_578786.validator(path, query, header, formData, body)
  let scheme = call_578786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578786.url(scheme.get, call_578786.host, call_578786.base,
                         call_578786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578786, url, valid)

proc call*(call_578857: Call_PubsubProjectsTopicsCreate_578610; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsCreate
  ## Creates the given topic with the given name.
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
  ##       : The name of the topic. It must have the format
  ## `"projects/{project}/topics/{topic}"`. `{topic}` must start with a letter,
  ## and contain only letters (`[A-Za-z]`), numbers (`[0-9]`), dashes (`-`),
  ## underscores (`_`), periods (`.`), tildes (`~`), plus (`+`) or percent
  ## signs (`%`). It must be between 3 and 255 characters in length, and it
  ## must not start with `"goog"`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578858 = newJObject()
  var query_578860 = newJObject()
  var body_578861 = newJObject()
  add(query_578860, "key", newJString(key))
  add(query_578860, "prettyPrint", newJBool(prettyPrint))
  add(query_578860, "oauth_token", newJString(oauthToken))
  add(query_578860, "$.xgafv", newJString(Xgafv))
  add(query_578860, "alt", newJString(alt))
  add(query_578860, "uploadType", newJString(uploadType))
  add(query_578860, "quotaUser", newJString(quotaUser))
  add(path_578858, "name", newJString(name))
  if body != nil:
    body_578861 = body
  add(query_578860, "callback", newJString(callback))
  add(query_578860, "fields", newJString(fields))
  add(query_578860, "access_token", newJString(accessToken))
  add(query_578860, "upload_protocol", newJString(uploadProtocol))
  result = call_578857.call(path_578858, query_578860, nil, nil, body_578861)

var pubsubProjectsTopicsCreate* = Call_PubsubProjectsTopicsCreate_578610(
    name: "pubsubProjectsTopicsCreate", meth: HttpMethod.HttpPut,
    host: "pubsub.googleapis.com", route: "/v1beta2/{name}",
    validator: validate_PubsubProjectsTopicsCreate_578611, base: "/",
    url: url_PubsubProjectsTopicsCreate_578612, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsList_578900 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSubscriptionsList_578902(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsList_578901(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists matching subscriptions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The name of the cloud project that subscriptions belong to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578903 = path.getOrDefault("project")
  valid_578903 = validateParameter(valid_578903, JString, required = true,
                                 default = nil)
  if valid_578903 != nil:
    section.add "project", valid_578903
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
  ##           : Maximum number of subscriptions to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value returned by the last `ListSubscriptionsResponse`; indicates that
  ## this is a continuation of a prior `ListSubscriptions` call, and that the
  ## system should return the next page of data.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578904 = query.getOrDefault("key")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "key", valid_578904
  var valid_578905 = query.getOrDefault("prettyPrint")
  valid_578905 = validateParameter(valid_578905, JBool, required = false,
                                 default = newJBool(true))
  if valid_578905 != nil:
    section.add "prettyPrint", valid_578905
  var valid_578906 = query.getOrDefault("oauth_token")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "oauth_token", valid_578906
  var valid_578907 = query.getOrDefault("$.xgafv")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = newJString("1"))
  if valid_578907 != nil:
    section.add "$.xgafv", valid_578907
  var valid_578908 = query.getOrDefault("pageSize")
  valid_578908 = validateParameter(valid_578908, JInt, required = false, default = nil)
  if valid_578908 != nil:
    section.add "pageSize", valid_578908
  var valid_578909 = query.getOrDefault("alt")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = newJString("json"))
  if valid_578909 != nil:
    section.add "alt", valid_578909
  var valid_578910 = query.getOrDefault("uploadType")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "uploadType", valid_578910
  var valid_578911 = query.getOrDefault("quotaUser")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "quotaUser", valid_578911
  var valid_578912 = query.getOrDefault("pageToken")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "pageToken", valid_578912
  var valid_578913 = query.getOrDefault("callback")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "callback", valid_578913
  var valid_578914 = query.getOrDefault("fields")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "fields", valid_578914
  var valid_578915 = query.getOrDefault("access_token")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "access_token", valid_578915
  var valid_578916 = query.getOrDefault("upload_protocol")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "upload_protocol", valid_578916
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578917: Call_PubsubProjectsSubscriptionsList_578900;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists matching subscriptions.
  ## 
  let valid = call_578917.validator(path, query, header, formData, body)
  let scheme = call_578917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578917.url(scheme.get, call_578917.host, call_578917.base,
                         call_578917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578917, url, valid)

proc call*(call_578918: Call_PubsubProjectsSubscriptionsList_578900;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSubscriptionsList
  ## Lists matching subscriptions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of subscriptions to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The value returned by the last `ListSubscriptionsResponse`; indicates that
  ## this is a continuation of a prior `ListSubscriptions` call, and that the
  ## system should return the next page of data.
  ##   project: string (required)
  ##          : The name of the cloud project that subscriptions belong to.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578919 = newJObject()
  var query_578920 = newJObject()
  add(query_578920, "key", newJString(key))
  add(query_578920, "prettyPrint", newJBool(prettyPrint))
  add(query_578920, "oauth_token", newJString(oauthToken))
  add(query_578920, "$.xgafv", newJString(Xgafv))
  add(query_578920, "pageSize", newJInt(pageSize))
  add(query_578920, "alt", newJString(alt))
  add(query_578920, "uploadType", newJString(uploadType))
  add(query_578920, "quotaUser", newJString(quotaUser))
  add(query_578920, "pageToken", newJString(pageToken))
  add(path_578919, "project", newJString(project))
  add(query_578920, "callback", newJString(callback))
  add(query_578920, "fields", newJString(fields))
  add(query_578920, "access_token", newJString(accessToken))
  add(query_578920, "upload_protocol", newJString(uploadProtocol))
  result = call_578918.call(path_578919, query_578920, nil, nil, nil)

var pubsubProjectsSubscriptionsList* = Call_PubsubProjectsSubscriptionsList_578900(
    name: "pubsubProjectsSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1beta2/{project}/subscriptions",
    validator: validate_PubsubProjectsSubscriptionsList_578901, base: "/",
    url: url_PubsubProjectsSubscriptionsList_578902, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsList_578921 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsList_578923(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/topics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsList_578922(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists matching topics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The name of the cloud project that topics belong to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578924 = path.getOrDefault("project")
  valid_578924 = validateParameter(valid_578924, JString, required = true,
                                 default = nil)
  if valid_578924 != nil:
    section.add "project", valid_578924
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
  ##           : Maximum number of topics to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value returned by the last `ListTopicsResponse`; indicates that this is
  ## a continuation of a prior `ListTopics` call, and that the system should
  ## return the next page of data.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578925 = query.getOrDefault("key")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "key", valid_578925
  var valid_578926 = query.getOrDefault("prettyPrint")
  valid_578926 = validateParameter(valid_578926, JBool, required = false,
                                 default = newJBool(true))
  if valid_578926 != nil:
    section.add "prettyPrint", valid_578926
  var valid_578927 = query.getOrDefault("oauth_token")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "oauth_token", valid_578927
  var valid_578928 = query.getOrDefault("$.xgafv")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = newJString("1"))
  if valid_578928 != nil:
    section.add "$.xgafv", valid_578928
  var valid_578929 = query.getOrDefault("pageSize")
  valid_578929 = validateParameter(valid_578929, JInt, required = false, default = nil)
  if valid_578929 != nil:
    section.add "pageSize", valid_578929
  var valid_578930 = query.getOrDefault("alt")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = newJString("json"))
  if valid_578930 != nil:
    section.add "alt", valid_578930
  var valid_578931 = query.getOrDefault("uploadType")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "uploadType", valid_578931
  var valid_578932 = query.getOrDefault("quotaUser")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "quotaUser", valid_578932
  var valid_578933 = query.getOrDefault("pageToken")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "pageToken", valid_578933
  var valid_578934 = query.getOrDefault("callback")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "callback", valid_578934
  var valid_578935 = query.getOrDefault("fields")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "fields", valid_578935
  var valid_578936 = query.getOrDefault("access_token")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "access_token", valid_578936
  var valid_578937 = query.getOrDefault("upload_protocol")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "upload_protocol", valid_578937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578938: Call_PubsubProjectsTopicsList_578921; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists matching topics.
  ## 
  let valid = call_578938.validator(path, query, header, formData, body)
  let scheme = call_578938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578938.url(scheme.get, call_578938.host, call_578938.base,
                         call_578938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578938, url, valid)

proc call*(call_578939: Call_PubsubProjectsTopicsList_578921; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsList
  ## Lists matching topics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of topics to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The value returned by the last `ListTopicsResponse`; indicates that this is
  ## a continuation of a prior `ListTopics` call, and that the system should
  ## return the next page of data.
  ##   project: string (required)
  ##          : The name of the cloud project that topics belong to.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578940 = newJObject()
  var query_578941 = newJObject()
  add(query_578941, "key", newJString(key))
  add(query_578941, "prettyPrint", newJBool(prettyPrint))
  add(query_578941, "oauth_token", newJString(oauthToken))
  add(query_578941, "$.xgafv", newJString(Xgafv))
  add(query_578941, "pageSize", newJInt(pageSize))
  add(query_578941, "alt", newJString(alt))
  add(query_578941, "uploadType", newJString(uploadType))
  add(query_578941, "quotaUser", newJString(quotaUser))
  add(query_578941, "pageToken", newJString(pageToken))
  add(path_578940, "project", newJString(project))
  add(query_578941, "callback", newJString(callback))
  add(query_578941, "fields", newJString(fields))
  add(query_578941, "access_token", newJString(accessToken))
  add(query_578941, "upload_protocol", newJString(uploadProtocol))
  result = call_578939.call(path_578940, query_578941, nil, nil, nil)

var pubsubProjectsTopicsList* = Call_PubsubProjectsTopicsList_578921(
    name: "pubsubProjectsTopicsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1beta2/{project}/topics",
    validator: validate_PubsubProjectsTopicsList_578922, base: "/",
    url: url_PubsubProjectsTopicsList_578923, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsGetIamPolicy_578942 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsGetIamPolicy_578944(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsGetIamPolicy_578943(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_578945 = path.getOrDefault("resource")
  valid_578945 = validateParameter(valid_578945, JString, required = true,
                                 default = nil)
  if valid_578945 != nil:
    section.add "resource", valid_578945
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
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
  var valid_578946 = query.getOrDefault("key")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "key", valid_578946
  var valid_578947 = query.getOrDefault("prettyPrint")
  valid_578947 = validateParameter(valid_578947, JBool, required = false,
                                 default = newJBool(true))
  if valid_578947 != nil:
    section.add "prettyPrint", valid_578947
  var valid_578948 = query.getOrDefault("oauth_token")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "oauth_token", valid_578948
  var valid_578949 = query.getOrDefault("$.xgafv")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("1"))
  if valid_578949 != nil:
    section.add "$.xgafv", valid_578949
  var valid_578950 = query.getOrDefault("options.requestedPolicyVersion")
  valid_578950 = validateParameter(valid_578950, JInt, required = false, default = nil)
  if valid_578950 != nil:
    section.add "options.requestedPolicyVersion", valid_578950
  var valid_578951 = query.getOrDefault("alt")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = newJString("json"))
  if valid_578951 != nil:
    section.add "alt", valid_578951
  var valid_578952 = query.getOrDefault("uploadType")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "uploadType", valid_578952
  var valid_578953 = query.getOrDefault("quotaUser")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "quotaUser", valid_578953
  var valid_578954 = query.getOrDefault("callback")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "callback", valid_578954
  var valid_578955 = query.getOrDefault("fields")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "fields", valid_578955
  var valid_578956 = query.getOrDefault("access_token")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "access_token", valid_578956
  var valid_578957 = query.getOrDefault("upload_protocol")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "upload_protocol", valid_578957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578958: Call_PubsubProjectsTopicsGetIamPolicy_578942;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_578958.validator(path, query, header, formData, body)
  let scheme = call_578958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578958.url(scheme.get, call_578958.host, call_578958.base,
                         call_578958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578958, url, valid)

proc call*(call_578959: Call_PubsubProjectsTopicsGetIamPolicy_578942;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          optionsRequestedPolicyVersion: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsGetIamPolicy
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578960 = newJObject()
  var query_578961 = newJObject()
  add(query_578961, "key", newJString(key))
  add(query_578961, "prettyPrint", newJBool(prettyPrint))
  add(query_578961, "oauth_token", newJString(oauthToken))
  add(query_578961, "$.xgafv", newJString(Xgafv))
  add(query_578961, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_578961, "alt", newJString(alt))
  add(query_578961, "uploadType", newJString(uploadType))
  add(query_578961, "quotaUser", newJString(quotaUser))
  add(path_578960, "resource", newJString(resource))
  add(query_578961, "callback", newJString(callback))
  add(query_578961, "fields", newJString(fields))
  add(query_578961, "access_token", newJString(accessToken))
  add(query_578961, "upload_protocol", newJString(uploadProtocol))
  result = call_578959.call(path_578960, query_578961, nil, nil, nil)

var pubsubProjectsTopicsGetIamPolicy* = Call_PubsubProjectsTopicsGetIamPolicy_578942(
    name: "pubsubProjectsTopicsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1beta2/{resource}:getIamPolicy",
    validator: validate_PubsubProjectsTopicsGetIamPolicy_578943, base: "/",
    url: url_PubsubProjectsTopicsGetIamPolicy_578944, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsSetIamPolicy_578962 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsSetIamPolicy_578964(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsSetIamPolicy_578963(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_578965 = path.getOrDefault("resource")
  valid_578965 = validateParameter(valid_578965, JString, required = true,
                                 default = nil)
  if valid_578965 != nil:
    section.add "resource", valid_578965
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

proc call*(call_578978: Call_PubsubProjectsTopicsSetIamPolicy_578962;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_578978.validator(path, query, header, formData, body)
  let scheme = call_578978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578978.url(scheme.get, call_578978.host, call_578978.base,
                         call_578978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578978, url, valid)

proc call*(call_578979: Call_PubsubProjectsTopicsSetIamPolicy_578962;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
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
  add(query_578981, "alt", newJString(alt))
  add(query_578981, "uploadType", newJString(uploadType))
  add(query_578981, "quotaUser", newJString(quotaUser))
  add(path_578980, "resource", newJString(resource))
  if body != nil:
    body_578982 = body
  add(query_578981, "callback", newJString(callback))
  add(query_578981, "fields", newJString(fields))
  add(query_578981, "access_token", newJString(accessToken))
  add(query_578981, "upload_protocol", newJString(uploadProtocol))
  result = call_578979.call(path_578980, query_578981, nil, nil, body_578982)

var pubsubProjectsTopicsSetIamPolicy* = Call_PubsubProjectsTopicsSetIamPolicy_578962(
    name: "pubsubProjectsTopicsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta2/{resource}:setIamPolicy",
    validator: validate_PubsubProjectsTopicsSetIamPolicy_578963, base: "/",
    url: url_PubsubProjectsTopicsSetIamPolicy_578964, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsTestIamPermissions_578983 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsTestIamPermissions_578985(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsTestIamPermissions_578984(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_578986 = path.getOrDefault("resource")
  valid_578986 = validateParameter(valid_578986, JString, required = true,
                                 default = nil)
  if valid_578986 != nil:
    section.add "resource", valid_578986
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

proc call*(call_578999: Call_PubsubProjectsTopicsTestIamPermissions_578983;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  let valid = call_578999.validator(path, query, header, formData, body)
  let scheme = call_578999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578999.url(scheme.get, call_578999.host, call_578999.base,
                         call_578999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578999, url, valid)

proc call*(call_579000: Call_PubsubProjectsTopicsTestIamPermissions_578983;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
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
  add(query_579002, "alt", newJString(alt))
  add(query_579002, "uploadType", newJString(uploadType))
  add(query_579002, "quotaUser", newJString(quotaUser))
  add(path_579001, "resource", newJString(resource))
  if body != nil:
    body_579003 = body
  add(query_579002, "callback", newJString(callback))
  add(query_579002, "fields", newJString(fields))
  add(query_579002, "access_token", newJString(accessToken))
  add(query_579002, "upload_protocol", newJString(uploadProtocol))
  result = call_579000.call(path_579001, query_579002, nil, nil, body_579003)

var pubsubProjectsTopicsTestIamPermissions* = Call_PubsubProjectsTopicsTestIamPermissions_578983(
    name: "pubsubProjectsTopicsTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com",
    route: "/v1beta2/{resource}:testIamPermissions",
    validator: validate_PubsubProjectsTopicsTestIamPermissions_578984, base: "/",
    url: url_PubsubProjectsTopicsTestIamPermissions_578985,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsGet_579004 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSubscriptionsGet_579006(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "subscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsGet_579005(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the configuration details of a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The name of the subscription to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_579007 = path.getOrDefault("subscription")
  valid_579007 = validateParameter(valid_579007, JString, required = true,
                                 default = nil)
  if valid_579007 != nil:
    section.add "subscription", valid_579007
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
  if body != nil:
    result.add "body", body

proc call*(call_579019: Call_PubsubProjectsSubscriptionsGet_579004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration details of a subscription.
  ## 
  let valid = call_579019.validator(path, query, header, formData, body)
  let scheme = call_579019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579019.url(scheme.get, call_579019.host, call_579019.base,
                         call_579019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579019, url, valid)

proc call*(call_579020: Call_PubsubProjectsSubscriptionsGet_579004;
          subscription: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSubscriptionsGet
  ## Gets the configuration details of a subscription.
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
  ##   subscription: string (required)
  ##               : The name of the subscription to get.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579021 = newJObject()
  var query_579022 = newJObject()
  add(query_579022, "key", newJString(key))
  add(query_579022, "prettyPrint", newJBool(prettyPrint))
  add(query_579022, "oauth_token", newJString(oauthToken))
  add(query_579022, "$.xgafv", newJString(Xgafv))
  add(query_579022, "alt", newJString(alt))
  add(query_579022, "uploadType", newJString(uploadType))
  add(query_579022, "quotaUser", newJString(quotaUser))
  add(path_579021, "subscription", newJString(subscription))
  add(query_579022, "callback", newJString(callback))
  add(query_579022, "fields", newJString(fields))
  add(query_579022, "access_token", newJString(accessToken))
  add(query_579022, "upload_protocol", newJString(uploadProtocol))
  result = call_579020.call(path_579021, query_579022, nil, nil, nil)

var pubsubProjectsSubscriptionsGet* = Call_PubsubProjectsSubscriptionsGet_579004(
    name: "pubsubProjectsSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1beta2/{subscription}",
    validator: validate_PubsubProjectsSubscriptionsGet_579005, base: "/",
    url: url_PubsubProjectsSubscriptionsGet_579006, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsDelete_579023 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSubscriptionsDelete_579025(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "subscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsDelete_579024(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing subscription. All pending messages in the subscription
  ## are immediately dropped. Calls to `Pull` after deletion will return
  ## `NOT_FOUND`. After a subscription is deleted, a new one may be created with
  ## the same name, but the new one has no association with the old
  ## subscription, or its topic unless the same topic is specified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The subscription to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_579026 = path.getOrDefault("subscription")
  valid_579026 = validateParameter(valid_579026, JString, required = true,
                                 default = nil)
  if valid_579026 != nil:
    section.add "subscription", valid_579026
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
  var valid_579027 = query.getOrDefault("key")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "key", valid_579027
  var valid_579028 = query.getOrDefault("prettyPrint")
  valid_579028 = validateParameter(valid_579028, JBool, required = false,
                                 default = newJBool(true))
  if valid_579028 != nil:
    section.add "prettyPrint", valid_579028
  var valid_579029 = query.getOrDefault("oauth_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "oauth_token", valid_579029
  var valid_579030 = query.getOrDefault("$.xgafv")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = newJString("1"))
  if valid_579030 != nil:
    section.add "$.xgafv", valid_579030
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
  var valid_579034 = query.getOrDefault("callback")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "callback", valid_579034
  var valid_579035 = query.getOrDefault("fields")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "fields", valid_579035
  var valid_579036 = query.getOrDefault("access_token")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "access_token", valid_579036
  var valid_579037 = query.getOrDefault("upload_protocol")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "upload_protocol", valid_579037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579038: Call_PubsubProjectsSubscriptionsDelete_579023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing subscription. All pending messages in the subscription
  ## are immediately dropped. Calls to `Pull` after deletion will return
  ## `NOT_FOUND`. After a subscription is deleted, a new one may be created with
  ## the same name, but the new one has no association with the old
  ## subscription, or its topic unless the same topic is specified.
  ## 
  let valid = call_579038.validator(path, query, header, formData, body)
  let scheme = call_579038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579038.url(scheme.get, call_579038.host, call_579038.base,
                         call_579038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579038, url, valid)

proc call*(call_579039: Call_PubsubProjectsSubscriptionsDelete_579023;
          subscription: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSubscriptionsDelete
  ## Deletes an existing subscription. All pending messages in the subscription
  ## are immediately dropped. Calls to `Pull` after deletion will return
  ## `NOT_FOUND`. After a subscription is deleted, a new one may be created with
  ## the same name, but the new one has no association with the old
  ## subscription, or its topic unless the same topic is specified.
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
  ##   subscription: string (required)
  ##               : The subscription to delete.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579040 = newJObject()
  var query_579041 = newJObject()
  add(query_579041, "key", newJString(key))
  add(query_579041, "prettyPrint", newJBool(prettyPrint))
  add(query_579041, "oauth_token", newJString(oauthToken))
  add(query_579041, "$.xgafv", newJString(Xgafv))
  add(query_579041, "alt", newJString(alt))
  add(query_579041, "uploadType", newJString(uploadType))
  add(query_579041, "quotaUser", newJString(quotaUser))
  add(path_579040, "subscription", newJString(subscription))
  add(query_579041, "callback", newJString(callback))
  add(query_579041, "fields", newJString(fields))
  add(query_579041, "access_token", newJString(accessToken))
  add(query_579041, "upload_protocol", newJString(uploadProtocol))
  result = call_579039.call(path_579040, query_579041, nil, nil, nil)

var pubsubProjectsSubscriptionsDelete* = Call_PubsubProjectsSubscriptionsDelete_579023(
    name: "pubsubProjectsSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com", route: "/v1beta2/{subscription}",
    validator: validate_PubsubProjectsSubscriptionsDelete_579024, base: "/",
    url: url_PubsubProjectsSubscriptionsDelete_579025, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsAcknowledge_579042 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSubscriptionsAcknowledge_579044(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "subscription"),
               (kind: ConstantSegment, value: ":acknowledge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsAcknowledge_579043(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Acknowledges the messages associated with the `ack_ids` in the
  ## `AcknowledgeRequest`. The Pub/Sub system can remove the relevant messages
  ## from the subscription.
  ## 
  ## Acknowledging a message whose ack deadline has expired may succeed,
  ## but such a message may be redelivered later. Acknowledging a message more
  ## than once will not result in an error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The subscription whose message is being acknowledged.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_579045 = path.getOrDefault("subscription")
  valid_579045 = validateParameter(valid_579045, JString, required = true,
                                 default = nil)
  if valid_579045 != nil:
    section.add "subscription", valid_579045
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
  var valid_579046 = query.getOrDefault("key")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "key", valid_579046
  var valid_579047 = query.getOrDefault("prettyPrint")
  valid_579047 = validateParameter(valid_579047, JBool, required = false,
                                 default = newJBool(true))
  if valid_579047 != nil:
    section.add "prettyPrint", valid_579047
  var valid_579048 = query.getOrDefault("oauth_token")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "oauth_token", valid_579048
  var valid_579049 = query.getOrDefault("$.xgafv")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = newJString("1"))
  if valid_579049 != nil:
    section.add "$.xgafv", valid_579049
  var valid_579050 = query.getOrDefault("alt")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = newJString("json"))
  if valid_579050 != nil:
    section.add "alt", valid_579050
  var valid_579051 = query.getOrDefault("uploadType")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "uploadType", valid_579051
  var valid_579052 = query.getOrDefault("quotaUser")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "quotaUser", valid_579052
  var valid_579053 = query.getOrDefault("callback")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "callback", valid_579053
  var valid_579054 = query.getOrDefault("fields")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "fields", valid_579054
  var valid_579055 = query.getOrDefault("access_token")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "access_token", valid_579055
  var valid_579056 = query.getOrDefault("upload_protocol")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "upload_protocol", valid_579056
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

proc call*(call_579058: Call_PubsubProjectsSubscriptionsAcknowledge_579042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Acknowledges the messages associated with the `ack_ids` in the
  ## `AcknowledgeRequest`. The Pub/Sub system can remove the relevant messages
  ## from the subscription.
  ## 
  ## Acknowledging a message whose ack deadline has expired may succeed,
  ## but such a message may be redelivered later. Acknowledging a message more
  ## than once will not result in an error.
  ## 
  let valid = call_579058.validator(path, query, header, formData, body)
  let scheme = call_579058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579058.url(scheme.get, call_579058.host, call_579058.base,
                         call_579058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579058, url, valid)

proc call*(call_579059: Call_PubsubProjectsSubscriptionsAcknowledge_579042;
          subscription: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSubscriptionsAcknowledge
  ## Acknowledges the messages associated with the `ack_ids` in the
  ## `AcknowledgeRequest`. The Pub/Sub system can remove the relevant messages
  ## from the subscription.
  ## 
  ## Acknowledging a message whose ack deadline has expired may succeed,
  ## but such a message may be redelivered later. Acknowledging a message more
  ## than once will not result in an error.
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
  ##   subscription: string (required)
  ##               : The subscription whose message is being acknowledged.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579060 = newJObject()
  var query_579061 = newJObject()
  var body_579062 = newJObject()
  add(query_579061, "key", newJString(key))
  add(query_579061, "prettyPrint", newJBool(prettyPrint))
  add(query_579061, "oauth_token", newJString(oauthToken))
  add(query_579061, "$.xgafv", newJString(Xgafv))
  add(query_579061, "alt", newJString(alt))
  add(query_579061, "uploadType", newJString(uploadType))
  add(query_579061, "quotaUser", newJString(quotaUser))
  add(path_579060, "subscription", newJString(subscription))
  if body != nil:
    body_579062 = body
  add(query_579061, "callback", newJString(callback))
  add(query_579061, "fields", newJString(fields))
  add(query_579061, "access_token", newJString(accessToken))
  add(query_579061, "upload_protocol", newJString(uploadProtocol))
  result = call_579059.call(path_579060, query_579061, nil, nil, body_579062)

var pubsubProjectsSubscriptionsAcknowledge* = Call_PubsubProjectsSubscriptionsAcknowledge_579042(
    name: "pubsubProjectsSubscriptionsAcknowledge", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta2/{subscription}:acknowledge",
    validator: validate_PubsubProjectsSubscriptionsAcknowledge_579043, base: "/",
    url: url_PubsubProjectsSubscriptionsAcknowledge_579044,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsModifyAckDeadline_579063 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSubscriptionsModifyAckDeadline_579065(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "subscription"),
               (kind: ConstantSegment, value: ":modifyAckDeadline")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsModifyAckDeadline_579064(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the ack deadline for a specific message. This method is useful
  ## to indicate that more time is needed to process a message by the
  ## subscriber, or to make the message available for redelivery if the
  ## processing was interrupted. Note that this does not modify the
  ## subscription-level `ackDeadlineSeconds` used for subsequent messages.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The name of the subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_579066 = path.getOrDefault("subscription")
  valid_579066 = validateParameter(valid_579066, JString, required = true,
                                 default = nil)
  if valid_579066 != nil:
    section.add "subscription", valid_579066
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
  var valid_579067 = query.getOrDefault("key")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "key", valid_579067
  var valid_579068 = query.getOrDefault("prettyPrint")
  valid_579068 = validateParameter(valid_579068, JBool, required = false,
                                 default = newJBool(true))
  if valid_579068 != nil:
    section.add "prettyPrint", valid_579068
  var valid_579069 = query.getOrDefault("oauth_token")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "oauth_token", valid_579069
  var valid_579070 = query.getOrDefault("$.xgafv")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = newJString("1"))
  if valid_579070 != nil:
    section.add "$.xgafv", valid_579070
  var valid_579071 = query.getOrDefault("alt")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = newJString("json"))
  if valid_579071 != nil:
    section.add "alt", valid_579071
  var valid_579072 = query.getOrDefault("uploadType")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "uploadType", valid_579072
  var valid_579073 = query.getOrDefault("quotaUser")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "quotaUser", valid_579073
  var valid_579074 = query.getOrDefault("callback")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "callback", valid_579074
  var valid_579075 = query.getOrDefault("fields")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "fields", valid_579075
  var valid_579076 = query.getOrDefault("access_token")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "access_token", valid_579076
  var valid_579077 = query.getOrDefault("upload_protocol")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "upload_protocol", valid_579077
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

proc call*(call_579079: Call_PubsubProjectsSubscriptionsModifyAckDeadline_579063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the ack deadline for a specific message. This method is useful
  ## to indicate that more time is needed to process a message by the
  ## subscriber, or to make the message available for redelivery if the
  ## processing was interrupted. Note that this does not modify the
  ## subscription-level `ackDeadlineSeconds` used for subsequent messages.
  ## 
  let valid = call_579079.validator(path, query, header, formData, body)
  let scheme = call_579079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579079.url(scheme.get, call_579079.host, call_579079.base,
                         call_579079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579079, url, valid)

proc call*(call_579080: Call_PubsubProjectsSubscriptionsModifyAckDeadline_579063;
          subscription: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSubscriptionsModifyAckDeadline
  ## Modifies the ack deadline for a specific message. This method is useful
  ## to indicate that more time is needed to process a message by the
  ## subscriber, or to make the message available for redelivery if the
  ## processing was interrupted. Note that this does not modify the
  ## subscription-level `ackDeadlineSeconds` used for subsequent messages.
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
  ##   subscription: string (required)
  ##               : The name of the subscription.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579081 = newJObject()
  var query_579082 = newJObject()
  var body_579083 = newJObject()
  add(query_579082, "key", newJString(key))
  add(query_579082, "prettyPrint", newJBool(prettyPrint))
  add(query_579082, "oauth_token", newJString(oauthToken))
  add(query_579082, "$.xgafv", newJString(Xgafv))
  add(query_579082, "alt", newJString(alt))
  add(query_579082, "uploadType", newJString(uploadType))
  add(query_579082, "quotaUser", newJString(quotaUser))
  add(path_579081, "subscription", newJString(subscription))
  if body != nil:
    body_579083 = body
  add(query_579082, "callback", newJString(callback))
  add(query_579082, "fields", newJString(fields))
  add(query_579082, "access_token", newJString(accessToken))
  add(query_579082, "upload_protocol", newJString(uploadProtocol))
  result = call_579080.call(path_579081, query_579082, nil, nil, body_579083)

var pubsubProjectsSubscriptionsModifyAckDeadline* = Call_PubsubProjectsSubscriptionsModifyAckDeadline_579063(
    name: "pubsubProjectsSubscriptionsModifyAckDeadline",
    meth: HttpMethod.HttpPost, host: "pubsub.googleapis.com",
    route: "/v1beta2/{subscription}:modifyAckDeadline",
    validator: validate_PubsubProjectsSubscriptionsModifyAckDeadline_579064,
    base: "/", url: url_PubsubProjectsSubscriptionsModifyAckDeadline_579065,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsModifyPushConfig_579084 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSubscriptionsModifyPushConfig_579086(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "subscription"),
               (kind: ConstantSegment, value: ":modifyPushConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsModifyPushConfig_579085(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the `PushConfig` for a specified subscription.
  ## 
  ## This may be used to change a push subscription to a pull one (signified by
  ## an empty `PushConfig`) or vice versa, or change the endpoint URL and other
  ## attributes of a push subscription. Messages will accumulate for delivery
  ## continuously through the call regardless of changes to the `PushConfig`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The name of the subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_579087 = path.getOrDefault("subscription")
  valid_579087 = validateParameter(valid_579087, JString, required = true,
                                 default = nil)
  if valid_579087 != nil:
    section.add "subscription", valid_579087
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
  var valid_579088 = query.getOrDefault("key")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "key", valid_579088
  var valid_579089 = query.getOrDefault("prettyPrint")
  valid_579089 = validateParameter(valid_579089, JBool, required = false,
                                 default = newJBool(true))
  if valid_579089 != nil:
    section.add "prettyPrint", valid_579089
  var valid_579090 = query.getOrDefault("oauth_token")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "oauth_token", valid_579090
  var valid_579091 = query.getOrDefault("$.xgafv")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = newJString("1"))
  if valid_579091 != nil:
    section.add "$.xgafv", valid_579091
  var valid_579092 = query.getOrDefault("alt")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = newJString("json"))
  if valid_579092 != nil:
    section.add "alt", valid_579092
  var valid_579093 = query.getOrDefault("uploadType")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "uploadType", valid_579093
  var valid_579094 = query.getOrDefault("quotaUser")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "quotaUser", valid_579094
  var valid_579095 = query.getOrDefault("callback")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "callback", valid_579095
  var valid_579096 = query.getOrDefault("fields")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "fields", valid_579096
  var valid_579097 = query.getOrDefault("access_token")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "access_token", valid_579097
  var valid_579098 = query.getOrDefault("upload_protocol")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "upload_protocol", valid_579098
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

proc call*(call_579100: Call_PubsubProjectsSubscriptionsModifyPushConfig_579084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the `PushConfig` for a specified subscription.
  ## 
  ## This may be used to change a push subscription to a pull one (signified by
  ## an empty `PushConfig`) or vice versa, or change the endpoint URL and other
  ## attributes of a push subscription. Messages will accumulate for delivery
  ## continuously through the call regardless of changes to the `PushConfig`.
  ## 
  let valid = call_579100.validator(path, query, header, formData, body)
  let scheme = call_579100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579100.url(scheme.get, call_579100.host, call_579100.base,
                         call_579100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579100, url, valid)

proc call*(call_579101: Call_PubsubProjectsSubscriptionsModifyPushConfig_579084;
          subscription: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSubscriptionsModifyPushConfig
  ## Modifies the `PushConfig` for a specified subscription.
  ## 
  ## This may be used to change a push subscription to a pull one (signified by
  ## an empty `PushConfig`) or vice versa, or change the endpoint URL and other
  ## attributes of a push subscription. Messages will accumulate for delivery
  ## continuously through the call regardless of changes to the `PushConfig`.
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
  ##   subscription: string (required)
  ##               : The name of the subscription.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579102 = newJObject()
  var query_579103 = newJObject()
  var body_579104 = newJObject()
  add(query_579103, "key", newJString(key))
  add(query_579103, "prettyPrint", newJBool(prettyPrint))
  add(query_579103, "oauth_token", newJString(oauthToken))
  add(query_579103, "$.xgafv", newJString(Xgafv))
  add(query_579103, "alt", newJString(alt))
  add(query_579103, "uploadType", newJString(uploadType))
  add(query_579103, "quotaUser", newJString(quotaUser))
  add(path_579102, "subscription", newJString(subscription))
  if body != nil:
    body_579104 = body
  add(query_579103, "callback", newJString(callback))
  add(query_579103, "fields", newJString(fields))
  add(query_579103, "access_token", newJString(accessToken))
  add(query_579103, "upload_protocol", newJString(uploadProtocol))
  result = call_579101.call(path_579102, query_579103, nil, nil, body_579104)

var pubsubProjectsSubscriptionsModifyPushConfig* = Call_PubsubProjectsSubscriptionsModifyPushConfig_579084(
    name: "pubsubProjectsSubscriptionsModifyPushConfig",
    meth: HttpMethod.HttpPost, host: "pubsub.googleapis.com",
    route: "/v1beta2/{subscription}:modifyPushConfig",
    validator: validate_PubsubProjectsSubscriptionsModifyPushConfig_579085,
    base: "/", url: url_PubsubProjectsSubscriptionsModifyPushConfig_579086,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsPull_579105 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsSubscriptionsPull_579107(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "subscription"),
               (kind: ConstantSegment, value: ":pull")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsPull_579106(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pulls messages from the server. Returns an empty list if there are no
  ## messages available in the backlog. The server may return `UNAVAILABLE` if
  ## there are too many concurrent pull requests pending for the given
  ## subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The subscription from which messages should be pulled.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_579108 = path.getOrDefault("subscription")
  valid_579108 = validateParameter(valid_579108, JString, required = true,
                                 default = nil)
  if valid_579108 != nil:
    section.add "subscription", valid_579108
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
  var valid_579109 = query.getOrDefault("key")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "key", valid_579109
  var valid_579110 = query.getOrDefault("prettyPrint")
  valid_579110 = validateParameter(valid_579110, JBool, required = false,
                                 default = newJBool(true))
  if valid_579110 != nil:
    section.add "prettyPrint", valid_579110
  var valid_579111 = query.getOrDefault("oauth_token")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "oauth_token", valid_579111
  var valid_579112 = query.getOrDefault("$.xgafv")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = newJString("1"))
  if valid_579112 != nil:
    section.add "$.xgafv", valid_579112
  var valid_579113 = query.getOrDefault("alt")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = newJString("json"))
  if valid_579113 != nil:
    section.add "alt", valid_579113
  var valid_579114 = query.getOrDefault("uploadType")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "uploadType", valid_579114
  var valid_579115 = query.getOrDefault("quotaUser")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "quotaUser", valid_579115
  var valid_579116 = query.getOrDefault("callback")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "callback", valid_579116
  var valid_579117 = query.getOrDefault("fields")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "fields", valid_579117
  var valid_579118 = query.getOrDefault("access_token")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "access_token", valid_579118
  var valid_579119 = query.getOrDefault("upload_protocol")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "upload_protocol", valid_579119
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

proc call*(call_579121: Call_PubsubProjectsSubscriptionsPull_579105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pulls messages from the server. Returns an empty list if there are no
  ## messages available in the backlog. The server may return `UNAVAILABLE` if
  ## there are too many concurrent pull requests pending for the given
  ## subscription.
  ## 
  let valid = call_579121.validator(path, query, header, formData, body)
  let scheme = call_579121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579121.url(scheme.get, call_579121.host, call_579121.base,
                         call_579121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579121, url, valid)

proc call*(call_579122: Call_PubsubProjectsSubscriptionsPull_579105;
          subscription: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsSubscriptionsPull
  ## Pulls messages from the server. Returns an empty list if there are no
  ## messages available in the backlog. The server may return `UNAVAILABLE` if
  ## there are too many concurrent pull requests pending for the given
  ## subscription.
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
  ##   subscription: string (required)
  ##               : The subscription from which messages should be pulled.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579123 = newJObject()
  var query_579124 = newJObject()
  var body_579125 = newJObject()
  add(query_579124, "key", newJString(key))
  add(query_579124, "prettyPrint", newJBool(prettyPrint))
  add(query_579124, "oauth_token", newJString(oauthToken))
  add(query_579124, "$.xgafv", newJString(Xgafv))
  add(query_579124, "alt", newJString(alt))
  add(query_579124, "uploadType", newJString(uploadType))
  add(query_579124, "quotaUser", newJString(quotaUser))
  add(path_579123, "subscription", newJString(subscription))
  if body != nil:
    body_579125 = body
  add(query_579124, "callback", newJString(callback))
  add(query_579124, "fields", newJString(fields))
  add(query_579124, "access_token", newJString(accessToken))
  add(query_579124, "upload_protocol", newJString(uploadProtocol))
  result = call_579122.call(path_579123, query_579124, nil, nil, body_579125)

var pubsubProjectsSubscriptionsPull* = Call_PubsubProjectsSubscriptionsPull_579105(
    name: "pubsubProjectsSubscriptionsPull", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta2/{subscription}:pull",
    validator: validate_PubsubProjectsSubscriptionsPull_579106, base: "/",
    url: url_PubsubProjectsSubscriptionsPull_579107, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsGet_579126 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsGet_579128(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "topic")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsGet_579127(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the configuration of a topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topic: JString (required)
  ##        : The name of the topic to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `topic` field"
  var valid_579129 = path.getOrDefault("topic")
  valid_579129 = validateParameter(valid_579129, JString, required = true,
                                 default = nil)
  if valid_579129 != nil:
    section.add "topic", valid_579129
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
  var valid_579137 = query.getOrDefault("callback")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "callback", valid_579137
  var valid_579138 = query.getOrDefault("fields")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "fields", valid_579138
  var valid_579139 = query.getOrDefault("access_token")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "access_token", valid_579139
  var valid_579140 = query.getOrDefault("upload_protocol")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "upload_protocol", valid_579140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579141: Call_PubsubProjectsTopicsGet_579126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration of a topic.
  ## 
  let valid = call_579141.validator(path, query, header, formData, body)
  let scheme = call_579141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579141.url(scheme.get, call_579141.host, call_579141.base,
                         call_579141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579141, url, valid)

proc call*(call_579142: Call_PubsubProjectsTopicsGet_579126; topic: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsGet
  ## Gets the configuration of a topic.
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
  ##   topic: string (required)
  ##        : The name of the topic to get.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579143 = newJObject()
  var query_579144 = newJObject()
  add(query_579144, "key", newJString(key))
  add(query_579144, "prettyPrint", newJBool(prettyPrint))
  add(query_579144, "oauth_token", newJString(oauthToken))
  add(query_579144, "$.xgafv", newJString(Xgafv))
  add(query_579144, "alt", newJString(alt))
  add(query_579144, "uploadType", newJString(uploadType))
  add(query_579144, "quotaUser", newJString(quotaUser))
  add(path_579143, "topic", newJString(topic))
  add(query_579144, "callback", newJString(callback))
  add(query_579144, "fields", newJString(fields))
  add(query_579144, "access_token", newJString(accessToken))
  add(query_579144, "upload_protocol", newJString(uploadProtocol))
  result = call_579142.call(path_579143, query_579144, nil, nil, nil)

var pubsubProjectsTopicsGet* = Call_PubsubProjectsTopicsGet_579126(
    name: "pubsubProjectsTopicsGet", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1beta2/{topic}",
    validator: validate_PubsubProjectsTopicsGet_579127, base: "/",
    url: url_PubsubProjectsTopicsGet_579128, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsDelete_579145 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsDelete_579147(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "topic")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsDelete_579146(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the topic with the given name. Returns `NOT_FOUND` if the topic
  ## does not exist. After a topic is deleted, a new topic may be created with
  ## the same name; this is an entirely new topic with none of the old
  ## configuration or subscriptions. Existing subscriptions to this topic are
  ## not deleted, but their `topic` field is set to `_deleted-topic_`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topic: JString (required)
  ##        : Name of the topic to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `topic` field"
  var valid_579148 = path.getOrDefault("topic")
  valid_579148 = validateParameter(valid_579148, JString, required = true,
                                 default = nil)
  if valid_579148 != nil:
    section.add "topic", valid_579148
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
  var valid_579149 = query.getOrDefault("key")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "key", valid_579149
  var valid_579150 = query.getOrDefault("prettyPrint")
  valid_579150 = validateParameter(valid_579150, JBool, required = false,
                                 default = newJBool(true))
  if valid_579150 != nil:
    section.add "prettyPrint", valid_579150
  var valid_579151 = query.getOrDefault("oauth_token")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "oauth_token", valid_579151
  var valid_579152 = query.getOrDefault("$.xgafv")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = newJString("1"))
  if valid_579152 != nil:
    section.add "$.xgafv", valid_579152
  var valid_579153 = query.getOrDefault("alt")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = newJString("json"))
  if valid_579153 != nil:
    section.add "alt", valid_579153
  var valid_579154 = query.getOrDefault("uploadType")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "uploadType", valid_579154
  var valid_579155 = query.getOrDefault("quotaUser")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "quotaUser", valid_579155
  var valid_579156 = query.getOrDefault("callback")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "callback", valid_579156
  var valid_579157 = query.getOrDefault("fields")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "fields", valid_579157
  var valid_579158 = query.getOrDefault("access_token")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "access_token", valid_579158
  var valid_579159 = query.getOrDefault("upload_protocol")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "upload_protocol", valid_579159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579160: Call_PubsubProjectsTopicsDelete_579145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the topic with the given name. Returns `NOT_FOUND` if the topic
  ## does not exist. After a topic is deleted, a new topic may be created with
  ## the same name; this is an entirely new topic with none of the old
  ## configuration or subscriptions. Existing subscriptions to this topic are
  ## not deleted, but their `topic` field is set to `_deleted-topic_`.
  ## 
  let valid = call_579160.validator(path, query, header, formData, body)
  let scheme = call_579160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579160.url(scheme.get, call_579160.host, call_579160.base,
                         call_579160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579160, url, valid)

proc call*(call_579161: Call_PubsubProjectsTopicsDelete_579145; topic: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsDelete
  ## Deletes the topic with the given name. Returns `NOT_FOUND` if the topic
  ## does not exist. After a topic is deleted, a new topic may be created with
  ## the same name; this is an entirely new topic with none of the old
  ## configuration or subscriptions. Existing subscriptions to this topic are
  ## not deleted, but their `topic` field is set to `_deleted-topic_`.
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
  ##   topic: string (required)
  ##        : Name of the topic to delete.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579162 = newJObject()
  var query_579163 = newJObject()
  add(query_579163, "key", newJString(key))
  add(query_579163, "prettyPrint", newJBool(prettyPrint))
  add(query_579163, "oauth_token", newJString(oauthToken))
  add(query_579163, "$.xgafv", newJString(Xgafv))
  add(query_579163, "alt", newJString(alt))
  add(query_579163, "uploadType", newJString(uploadType))
  add(query_579163, "quotaUser", newJString(quotaUser))
  add(path_579162, "topic", newJString(topic))
  add(query_579163, "callback", newJString(callback))
  add(query_579163, "fields", newJString(fields))
  add(query_579163, "access_token", newJString(accessToken))
  add(query_579163, "upload_protocol", newJString(uploadProtocol))
  result = call_579161.call(path_579162, query_579163, nil, nil, nil)

var pubsubProjectsTopicsDelete* = Call_PubsubProjectsTopicsDelete_579145(
    name: "pubsubProjectsTopicsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com", route: "/v1beta2/{topic}",
    validator: validate_PubsubProjectsTopicsDelete_579146, base: "/",
    url: url_PubsubProjectsTopicsDelete_579147, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsSubscriptionsList_579164 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsSubscriptionsList_579166(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "topic"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsSubscriptionsList_579165(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the name of the subscriptions for this topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topic: JString (required)
  ##        : The name of the topic that subscriptions are attached to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `topic` field"
  var valid_579167 = path.getOrDefault("topic")
  valid_579167 = validateParameter(valid_579167, JString, required = true,
                                 default = nil)
  if valid_579167 != nil:
    section.add "topic", valid_579167
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
  ##           : Maximum number of subscription names to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value returned by the last `ListTopicSubscriptionsResponse`; indicates
  ## that this is a continuation of a prior `ListTopicSubscriptions` call, and
  ## that the system should return the next page of data.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579168 = query.getOrDefault("key")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "key", valid_579168
  var valid_579169 = query.getOrDefault("prettyPrint")
  valid_579169 = validateParameter(valid_579169, JBool, required = false,
                                 default = newJBool(true))
  if valid_579169 != nil:
    section.add "prettyPrint", valid_579169
  var valid_579170 = query.getOrDefault("oauth_token")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "oauth_token", valid_579170
  var valid_579171 = query.getOrDefault("$.xgafv")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = newJString("1"))
  if valid_579171 != nil:
    section.add "$.xgafv", valid_579171
  var valid_579172 = query.getOrDefault("pageSize")
  valid_579172 = validateParameter(valid_579172, JInt, required = false, default = nil)
  if valid_579172 != nil:
    section.add "pageSize", valid_579172
  var valid_579173 = query.getOrDefault("alt")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = newJString("json"))
  if valid_579173 != nil:
    section.add "alt", valid_579173
  var valid_579174 = query.getOrDefault("uploadType")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "uploadType", valid_579174
  var valid_579175 = query.getOrDefault("quotaUser")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "quotaUser", valid_579175
  var valid_579176 = query.getOrDefault("pageToken")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "pageToken", valid_579176
  var valid_579177 = query.getOrDefault("callback")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "callback", valid_579177
  var valid_579178 = query.getOrDefault("fields")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "fields", valid_579178
  var valid_579179 = query.getOrDefault("access_token")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "access_token", valid_579179
  var valid_579180 = query.getOrDefault("upload_protocol")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "upload_protocol", valid_579180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579181: Call_PubsubProjectsTopicsSubscriptionsList_579164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the name of the subscriptions for this topic.
  ## 
  let valid = call_579181.validator(path, query, header, formData, body)
  let scheme = call_579181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579181.url(scheme.get, call_579181.host, call_579181.base,
                         call_579181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579181, url, valid)

proc call*(call_579182: Call_PubsubProjectsTopicsSubscriptionsList_579164;
          topic: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsSubscriptionsList
  ## Lists the name of the subscriptions for this topic.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of subscription names to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The value returned by the last `ListTopicSubscriptionsResponse`; indicates
  ## that this is a continuation of a prior `ListTopicSubscriptions` call, and
  ## that the system should return the next page of data.
  ##   topic: string (required)
  ##        : The name of the topic that subscriptions are attached to.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579183 = newJObject()
  var query_579184 = newJObject()
  add(query_579184, "key", newJString(key))
  add(query_579184, "prettyPrint", newJBool(prettyPrint))
  add(query_579184, "oauth_token", newJString(oauthToken))
  add(query_579184, "$.xgafv", newJString(Xgafv))
  add(query_579184, "pageSize", newJInt(pageSize))
  add(query_579184, "alt", newJString(alt))
  add(query_579184, "uploadType", newJString(uploadType))
  add(query_579184, "quotaUser", newJString(quotaUser))
  add(query_579184, "pageToken", newJString(pageToken))
  add(path_579183, "topic", newJString(topic))
  add(query_579184, "callback", newJString(callback))
  add(query_579184, "fields", newJString(fields))
  add(query_579184, "access_token", newJString(accessToken))
  add(query_579184, "upload_protocol", newJString(uploadProtocol))
  result = call_579182.call(path_579183, query_579184, nil, nil, nil)

var pubsubProjectsTopicsSubscriptionsList* = Call_PubsubProjectsTopicsSubscriptionsList_579164(
    name: "pubsubProjectsTopicsSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1beta2/{topic}/subscriptions",
    validator: validate_PubsubProjectsTopicsSubscriptionsList_579165, base: "/",
    url: url_PubsubProjectsTopicsSubscriptionsList_579166, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsPublish_579185 = ref object of OpenApiRestCall_578339
proc url_PubsubProjectsTopicsPublish_579187(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta2/"),
               (kind: VariableSegment, value: "topic"),
               (kind: ConstantSegment, value: ":publish")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsPublish_579186(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds one or more messages to the topic. Returns `NOT_FOUND` if the topic
  ## does not exist. The message payload must not be empty; it must contain
  ##  either a non-empty data field, or at least one attribute.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topic: JString (required)
  ##        : The messages in the request will be published on this topic.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `topic` field"
  var valid_579188 = path.getOrDefault("topic")
  valid_579188 = validateParameter(valid_579188, JString, required = true,
                                 default = nil)
  if valid_579188 != nil:
    section.add "topic", valid_579188
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
  var valid_579189 = query.getOrDefault("key")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "key", valid_579189
  var valid_579190 = query.getOrDefault("prettyPrint")
  valid_579190 = validateParameter(valid_579190, JBool, required = false,
                                 default = newJBool(true))
  if valid_579190 != nil:
    section.add "prettyPrint", valid_579190
  var valid_579191 = query.getOrDefault("oauth_token")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "oauth_token", valid_579191
  var valid_579192 = query.getOrDefault("$.xgafv")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = newJString("1"))
  if valid_579192 != nil:
    section.add "$.xgafv", valid_579192
  var valid_579193 = query.getOrDefault("alt")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = newJString("json"))
  if valid_579193 != nil:
    section.add "alt", valid_579193
  var valid_579194 = query.getOrDefault("uploadType")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "uploadType", valid_579194
  var valid_579195 = query.getOrDefault("quotaUser")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "quotaUser", valid_579195
  var valid_579196 = query.getOrDefault("callback")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "callback", valid_579196
  var valid_579197 = query.getOrDefault("fields")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "fields", valid_579197
  var valid_579198 = query.getOrDefault("access_token")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "access_token", valid_579198
  var valid_579199 = query.getOrDefault("upload_protocol")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "upload_protocol", valid_579199
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

proc call*(call_579201: Call_PubsubProjectsTopicsPublish_579185; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds one or more messages to the topic. Returns `NOT_FOUND` if the topic
  ## does not exist. The message payload must not be empty; it must contain
  ##  either a non-empty data field, or at least one attribute.
  ## 
  let valid = call_579201.validator(path, query, header, formData, body)
  let scheme = call_579201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579201.url(scheme.get, call_579201.host, call_579201.base,
                         call_579201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579201, url, valid)

proc call*(call_579202: Call_PubsubProjectsTopicsPublish_579185; topic: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubProjectsTopicsPublish
  ## Adds one or more messages to the topic. Returns `NOT_FOUND` if the topic
  ## does not exist. The message payload must not be empty; it must contain
  ##  either a non-empty data field, or at least one attribute.
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
  ##   topic: string (required)
  ##        : The messages in the request will be published on this topic.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579203 = newJObject()
  var query_579204 = newJObject()
  var body_579205 = newJObject()
  add(query_579204, "key", newJString(key))
  add(query_579204, "prettyPrint", newJBool(prettyPrint))
  add(query_579204, "oauth_token", newJString(oauthToken))
  add(query_579204, "$.xgafv", newJString(Xgafv))
  add(query_579204, "alt", newJString(alt))
  add(query_579204, "uploadType", newJString(uploadType))
  add(query_579204, "quotaUser", newJString(quotaUser))
  add(path_579203, "topic", newJString(topic))
  if body != nil:
    body_579205 = body
  add(query_579204, "callback", newJString(callback))
  add(query_579204, "fields", newJString(fields))
  add(query_579204, "access_token", newJString(accessToken))
  add(query_579204, "upload_protocol", newJString(uploadProtocol))
  result = call_579202.call(path_579203, query_579204, nil, nil, body_579205)

var pubsubProjectsTopicsPublish* = Call_PubsubProjectsTopicsPublish_579185(
    name: "pubsubProjectsTopicsPublish", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta2/{topic}:publish",
    validator: validate_PubsubProjectsTopicsPublish_579186, base: "/",
    url: url_PubsubProjectsTopicsPublish_579187, schemes: {Scheme.Https})
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
