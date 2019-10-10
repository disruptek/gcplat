
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
  gcpServiceName = "pubsub"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PubsubProjectsTopicsCreate_588710 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsCreate_588712(protocol: Scheme; host: string;
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

proc validate_PubsubProjectsTopicsCreate_588711(path: JsonNode; query: JsonNode;
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_588886: Call_PubsubProjectsTopicsCreate_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the given topic with the given name.
  ## 
  let valid = call_588886.validator(path, query, header, formData, body)
  let scheme = call_588886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588886.url(scheme.get, call_588886.host, call_588886.base,
                         call_588886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588886, url, valid)

proc call*(call_588957: Call_PubsubProjectsTopicsCreate_588710; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## pubsubProjectsTopicsCreate
  ## Creates the given topic with the given name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the topic. It must have the format
  ## `"projects/{project}/topics/{topic}"`. `{topic}` must start with a letter,
  ## and contain only letters (`[A-Za-z]`), numbers (`[0-9]`), dashes (`-`),
  ## underscores (`_`), periods (`.`), tildes (`~`), plus (`+`) or percent
  ## signs (`%`). It must be between 3 and 255 characters in length, and it
  ## must not start with `"goog"`.
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
  var path_588958 = newJObject()
  var query_588960 = newJObject()
  var body_588961 = newJObject()
  add(query_588960, "upload_protocol", newJString(uploadProtocol))
  add(query_588960, "fields", newJString(fields))
  add(query_588960, "quotaUser", newJString(quotaUser))
  add(path_588958, "name", newJString(name))
  add(query_588960, "alt", newJString(alt))
  add(query_588960, "oauth_token", newJString(oauthToken))
  add(query_588960, "callback", newJString(callback))
  add(query_588960, "access_token", newJString(accessToken))
  add(query_588960, "uploadType", newJString(uploadType))
  add(query_588960, "key", newJString(key))
  add(query_588960, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_588961 = body
  add(query_588960, "prettyPrint", newJBool(prettyPrint))
  result = call_588957.call(path_588958, query_588960, nil, nil, body_588961)

var pubsubProjectsTopicsCreate* = Call_PubsubProjectsTopicsCreate_588710(
    name: "pubsubProjectsTopicsCreate", meth: HttpMethod.HttpPut,
    host: "pubsub.googleapis.com", route: "/v1beta2/{name}",
    validator: validate_PubsubProjectsTopicsCreate_588711, base: "/",
    url: url_PubsubProjectsTopicsCreate_588712, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsList_589000 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSubscriptionsList_589002(protocol: Scheme; host: string;
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

proc validate_PubsubProjectsSubscriptionsList_589001(path: JsonNode;
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
  var valid_589003 = path.getOrDefault("project")
  valid_589003 = validateParameter(valid_589003, JString, required = true,
                                 default = nil)
  if valid_589003 != nil:
    section.add "project", valid_589003
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value returned by the last `ListSubscriptionsResponse`; indicates that
  ## this is a continuation of a prior `ListSubscriptions` call, and that the
  ## system should return the next page of data.
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
  ##           : Maximum number of subscriptions to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589004 = query.getOrDefault("upload_protocol")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "upload_protocol", valid_589004
  var valid_589005 = query.getOrDefault("fields")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "fields", valid_589005
  var valid_589006 = query.getOrDefault("pageToken")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "pageToken", valid_589006
  var valid_589007 = query.getOrDefault("quotaUser")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "quotaUser", valid_589007
  var valid_589008 = query.getOrDefault("alt")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = newJString("json"))
  if valid_589008 != nil:
    section.add "alt", valid_589008
  var valid_589009 = query.getOrDefault("oauth_token")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "oauth_token", valid_589009
  var valid_589010 = query.getOrDefault("callback")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "callback", valid_589010
  var valid_589011 = query.getOrDefault("access_token")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "access_token", valid_589011
  var valid_589012 = query.getOrDefault("uploadType")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "uploadType", valid_589012
  var valid_589013 = query.getOrDefault("key")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "key", valid_589013
  var valid_589014 = query.getOrDefault("$.xgafv")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = newJString("1"))
  if valid_589014 != nil:
    section.add "$.xgafv", valid_589014
  var valid_589015 = query.getOrDefault("pageSize")
  valid_589015 = validateParameter(valid_589015, JInt, required = false, default = nil)
  if valid_589015 != nil:
    section.add "pageSize", valid_589015
  var valid_589016 = query.getOrDefault("prettyPrint")
  valid_589016 = validateParameter(valid_589016, JBool, required = false,
                                 default = newJBool(true))
  if valid_589016 != nil:
    section.add "prettyPrint", valid_589016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589017: Call_PubsubProjectsSubscriptionsList_589000;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists matching subscriptions.
  ## 
  let valid = call_589017.validator(path, query, header, formData, body)
  let scheme = call_589017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589017.url(scheme.get, call_589017.host, call_589017.base,
                         call_589017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589017, url, valid)

proc call*(call_589018: Call_PubsubProjectsSubscriptionsList_589000;
          project: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## pubsubProjectsSubscriptionsList
  ## Lists matching subscriptions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last `ListSubscriptionsResponse`; indicates that
  ## this is a continuation of a prior `ListSubscriptions` call, and that the
  ## system should return the next page of data.
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
  ##   pageSize: int
  ##           : Maximum number of subscriptions to return.
  ##   project: string (required)
  ##          : The name of the cloud project that subscriptions belong to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589019 = newJObject()
  var query_589020 = newJObject()
  add(query_589020, "upload_protocol", newJString(uploadProtocol))
  add(query_589020, "fields", newJString(fields))
  add(query_589020, "pageToken", newJString(pageToken))
  add(query_589020, "quotaUser", newJString(quotaUser))
  add(query_589020, "alt", newJString(alt))
  add(query_589020, "oauth_token", newJString(oauthToken))
  add(query_589020, "callback", newJString(callback))
  add(query_589020, "access_token", newJString(accessToken))
  add(query_589020, "uploadType", newJString(uploadType))
  add(query_589020, "key", newJString(key))
  add(query_589020, "$.xgafv", newJString(Xgafv))
  add(query_589020, "pageSize", newJInt(pageSize))
  add(path_589019, "project", newJString(project))
  add(query_589020, "prettyPrint", newJBool(prettyPrint))
  result = call_589018.call(path_589019, query_589020, nil, nil, nil)

var pubsubProjectsSubscriptionsList* = Call_PubsubProjectsSubscriptionsList_589000(
    name: "pubsubProjectsSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1beta2/{project}/subscriptions",
    validator: validate_PubsubProjectsSubscriptionsList_589001, base: "/",
    url: url_PubsubProjectsSubscriptionsList_589002, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsList_589021 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsList_589023(protocol: Scheme; host: string;
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

proc validate_PubsubProjectsTopicsList_589022(path: JsonNode; query: JsonNode;
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
  var valid_589024 = path.getOrDefault("project")
  valid_589024 = validateParameter(valid_589024, JString, required = true,
                                 default = nil)
  if valid_589024 != nil:
    section.add "project", valid_589024
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value returned by the last `ListTopicsResponse`; indicates that this is
  ## a continuation of a prior `ListTopics` call, and that the system should
  ## return the next page of data.
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
  ##           : Maximum number of topics to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589025 = query.getOrDefault("upload_protocol")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "upload_protocol", valid_589025
  var valid_589026 = query.getOrDefault("fields")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "fields", valid_589026
  var valid_589027 = query.getOrDefault("pageToken")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "pageToken", valid_589027
  var valid_589028 = query.getOrDefault("quotaUser")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "quotaUser", valid_589028
  var valid_589029 = query.getOrDefault("alt")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = newJString("json"))
  if valid_589029 != nil:
    section.add "alt", valid_589029
  var valid_589030 = query.getOrDefault("oauth_token")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "oauth_token", valid_589030
  var valid_589031 = query.getOrDefault("callback")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "callback", valid_589031
  var valid_589032 = query.getOrDefault("access_token")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "access_token", valid_589032
  var valid_589033 = query.getOrDefault("uploadType")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "uploadType", valid_589033
  var valid_589034 = query.getOrDefault("key")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "key", valid_589034
  var valid_589035 = query.getOrDefault("$.xgafv")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = newJString("1"))
  if valid_589035 != nil:
    section.add "$.xgafv", valid_589035
  var valid_589036 = query.getOrDefault("pageSize")
  valid_589036 = validateParameter(valid_589036, JInt, required = false, default = nil)
  if valid_589036 != nil:
    section.add "pageSize", valid_589036
  var valid_589037 = query.getOrDefault("prettyPrint")
  valid_589037 = validateParameter(valid_589037, JBool, required = false,
                                 default = newJBool(true))
  if valid_589037 != nil:
    section.add "prettyPrint", valid_589037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589038: Call_PubsubProjectsTopicsList_589021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists matching topics.
  ## 
  let valid = call_589038.validator(path, query, header, formData, body)
  let scheme = call_589038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589038.url(scheme.get, call_589038.host, call_589038.base,
                         call_589038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589038, url, valid)

proc call*(call_589039: Call_PubsubProjectsTopicsList_589021; project: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## pubsubProjectsTopicsList
  ## Lists matching topics.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last `ListTopicsResponse`; indicates that this is
  ## a continuation of a prior `ListTopics` call, and that the system should
  ## return the next page of data.
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
  ##   pageSize: int
  ##           : Maximum number of topics to return.
  ##   project: string (required)
  ##          : The name of the cloud project that topics belong to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589040 = newJObject()
  var query_589041 = newJObject()
  add(query_589041, "upload_protocol", newJString(uploadProtocol))
  add(query_589041, "fields", newJString(fields))
  add(query_589041, "pageToken", newJString(pageToken))
  add(query_589041, "quotaUser", newJString(quotaUser))
  add(query_589041, "alt", newJString(alt))
  add(query_589041, "oauth_token", newJString(oauthToken))
  add(query_589041, "callback", newJString(callback))
  add(query_589041, "access_token", newJString(accessToken))
  add(query_589041, "uploadType", newJString(uploadType))
  add(query_589041, "key", newJString(key))
  add(query_589041, "$.xgafv", newJString(Xgafv))
  add(query_589041, "pageSize", newJInt(pageSize))
  add(path_589040, "project", newJString(project))
  add(query_589041, "prettyPrint", newJBool(prettyPrint))
  result = call_589039.call(path_589040, query_589041, nil, nil, nil)

var pubsubProjectsTopicsList* = Call_PubsubProjectsTopicsList_589021(
    name: "pubsubProjectsTopicsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1beta2/{project}/topics",
    validator: validate_PubsubProjectsTopicsList_589022, base: "/",
    url: url_PubsubProjectsTopicsList_589023, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsGetIamPolicy_589042 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsGetIamPolicy_589044(protocol: Scheme; host: string;
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

proc validate_PubsubProjectsTopicsGetIamPolicy_589043(path: JsonNode;
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
  var valid_589045 = path.getOrDefault("resource")
  valid_589045 = validateParameter(valid_589045, JString, required = true,
                                 default = nil)
  if valid_589045 != nil:
    section.add "resource", valid_589045
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589046 = query.getOrDefault("upload_protocol")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "upload_protocol", valid_589046
  var valid_589047 = query.getOrDefault("fields")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "fields", valid_589047
  var valid_589048 = query.getOrDefault("quotaUser")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "quotaUser", valid_589048
  var valid_589049 = query.getOrDefault("alt")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = newJString("json"))
  if valid_589049 != nil:
    section.add "alt", valid_589049
  var valid_589050 = query.getOrDefault("oauth_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "oauth_token", valid_589050
  var valid_589051 = query.getOrDefault("callback")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "callback", valid_589051
  var valid_589052 = query.getOrDefault("access_token")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "access_token", valid_589052
  var valid_589053 = query.getOrDefault("uploadType")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "uploadType", valid_589053
  var valid_589054 = query.getOrDefault("options.requestedPolicyVersion")
  valid_589054 = validateParameter(valid_589054, JInt, required = false, default = nil)
  if valid_589054 != nil:
    section.add "options.requestedPolicyVersion", valid_589054
  var valid_589055 = query.getOrDefault("key")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "key", valid_589055
  var valid_589056 = query.getOrDefault("$.xgafv")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = newJString("1"))
  if valid_589056 != nil:
    section.add "$.xgafv", valid_589056
  var valid_589057 = query.getOrDefault("prettyPrint")
  valid_589057 = validateParameter(valid_589057, JBool, required = false,
                                 default = newJBool(true))
  if valid_589057 != nil:
    section.add "prettyPrint", valid_589057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589058: Call_PubsubProjectsTopicsGetIamPolicy_589042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_589058.validator(path, query, header, formData, body)
  let scheme = call_589058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589058.url(scheme.get, call_589058.host, call_589058.base,
                         call_589058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589058, url, valid)

proc call*(call_589059: Call_PubsubProjectsTopicsGetIamPolicy_589042;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## pubsubProjectsTopicsGetIamPolicy
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
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
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589060 = newJObject()
  var query_589061 = newJObject()
  add(query_589061, "upload_protocol", newJString(uploadProtocol))
  add(query_589061, "fields", newJString(fields))
  add(query_589061, "quotaUser", newJString(quotaUser))
  add(query_589061, "alt", newJString(alt))
  add(query_589061, "oauth_token", newJString(oauthToken))
  add(query_589061, "callback", newJString(callback))
  add(query_589061, "access_token", newJString(accessToken))
  add(query_589061, "uploadType", newJString(uploadType))
  add(query_589061, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_589061, "key", newJString(key))
  add(query_589061, "$.xgafv", newJString(Xgafv))
  add(path_589060, "resource", newJString(resource))
  add(query_589061, "prettyPrint", newJBool(prettyPrint))
  result = call_589059.call(path_589060, query_589061, nil, nil, nil)

var pubsubProjectsTopicsGetIamPolicy* = Call_PubsubProjectsTopicsGetIamPolicy_589042(
    name: "pubsubProjectsTopicsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1beta2/{resource}:getIamPolicy",
    validator: validate_PubsubProjectsTopicsGetIamPolicy_589043, base: "/",
    url: url_PubsubProjectsTopicsGetIamPolicy_589044, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsSetIamPolicy_589062 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsSetIamPolicy_589064(protocol: Scheme; host: string;
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

proc validate_PubsubProjectsTopicsSetIamPolicy_589063(path: JsonNode;
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
  var valid_589065 = path.getOrDefault("resource")
  valid_589065 = validateParameter(valid_589065, JString, required = true,
                                 default = nil)
  if valid_589065 != nil:
    section.add "resource", valid_589065
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
  var valid_589066 = query.getOrDefault("upload_protocol")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "upload_protocol", valid_589066
  var valid_589067 = query.getOrDefault("fields")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "fields", valid_589067
  var valid_589068 = query.getOrDefault("quotaUser")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "quotaUser", valid_589068
  var valid_589069 = query.getOrDefault("alt")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = newJString("json"))
  if valid_589069 != nil:
    section.add "alt", valid_589069
  var valid_589070 = query.getOrDefault("oauth_token")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "oauth_token", valid_589070
  var valid_589071 = query.getOrDefault("callback")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "callback", valid_589071
  var valid_589072 = query.getOrDefault("access_token")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "access_token", valid_589072
  var valid_589073 = query.getOrDefault("uploadType")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "uploadType", valid_589073
  var valid_589074 = query.getOrDefault("key")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "key", valid_589074
  var valid_589075 = query.getOrDefault("$.xgafv")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("1"))
  if valid_589075 != nil:
    section.add "$.xgafv", valid_589075
  var valid_589076 = query.getOrDefault("prettyPrint")
  valid_589076 = validateParameter(valid_589076, JBool, required = false,
                                 default = newJBool(true))
  if valid_589076 != nil:
    section.add "prettyPrint", valid_589076
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

proc call*(call_589078: Call_PubsubProjectsTopicsSetIamPolicy_589062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_589078.validator(path, query, header, formData, body)
  let scheme = call_589078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589078.url(scheme.get, call_589078.host, call_589078.base,
                         call_589078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589078, url, valid)

proc call*(call_589079: Call_PubsubProjectsTopicsSetIamPolicy_589062;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## pubsubProjectsTopicsSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
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
  var path_589080 = newJObject()
  var query_589081 = newJObject()
  var body_589082 = newJObject()
  add(query_589081, "upload_protocol", newJString(uploadProtocol))
  add(query_589081, "fields", newJString(fields))
  add(query_589081, "quotaUser", newJString(quotaUser))
  add(query_589081, "alt", newJString(alt))
  add(query_589081, "oauth_token", newJString(oauthToken))
  add(query_589081, "callback", newJString(callback))
  add(query_589081, "access_token", newJString(accessToken))
  add(query_589081, "uploadType", newJString(uploadType))
  add(query_589081, "key", newJString(key))
  add(query_589081, "$.xgafv", newJString(Xgafv))
  add(path_589080, "resource", newJString(resource))
  if body != nil:
    body_589082 = body
  add(query_589081, "prettyPrint", newJBool(prettyPrint))
  result = call_589079.call(path_589080, query_589081, nil, nil, body_589082)

var pubsubProjectsTopicsSetIamPolicy* = Call_PubsubProjectsTopicsSetIamPolicy_589062(
    name: "pubsubProjectsTopicsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta2/{resource}:setIamPolicy",
    validator: validate_PubsubProjectsTopicsSetIamPolicy_589063, base: "/",
    url: url_PubsubProjectsTopicsSetIamPolicy_589064, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsTestIamPermissions_589083 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsTestIamPermissions_589085(protocol: Scheme;
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

proc validate_PubsubProjectsTopicsTestIamPermissions_589084(path: JsonNode;
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
  var valid_589086 = path.getOrDefault("resource")
  valid_589086 = validateParameter(valid_589086, JString, required = true,
                                 default = nil)
  if valid_589086 != nil:
    section.add "resource", valid_589086
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
  var valid_589087 = query.getOrDefault("upload_protocol")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "upload_protocol", valid_589087
  var valid_589088 = query.getOrDefault("fields")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "fields", valid_589088
  var valid_589089 = query.getOrDefault("quotaUser")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "quotaUser", valid_589089
  var valid_589090 = query.getOrDefault("alt")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = newJString("json"))
  if valid_589090 != nil:
    section.add "alt", valid_589090
  var valid_589091 = query.getOrDefault("oauth_token")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "oauth_token", valid_589091
  var valid_589092 = query.getOrDefault("callback")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "callback", valid_589092
  var valid_589093 = query.getOrDefault("access_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "access_token", valid_589093
  var valid_589094 = query.getOrDefault("uploadType")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "uploadType", valid_589094
  var valid_589095 = query.getOrDefault("key")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "key", valid_589095
  var valid_589096 = query.getOrDefault("$.xgafv")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = newJString("1"))
  if valid_589096 != nil:
    section.add "$.xgafv", valid_589096
  var valid_589097 = query.getOrDefault("prettyPrint")
  valid_589097 = validateParameter(valid_589097, JBool, required = false,
                                 default = newJBool(true))
  if valid_589097 != nil:
    section.add "prettyPrint", valid_589097
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

proc call*(call_589099: Call_PubsubProjectsTopicsTestIamPermissions_589083;
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
  let valid = call_589099.validator(path, query, header, formData, body)
  let scheme = call_589099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589099.url(scheme.get, call_589099.host, call_589099.base,
                         call_589099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589099, url, valid)

proc call*(call_589100: Call_PubsubProjectsTopicsTestIamPermissions_589083;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## pubsubProjectsTopicsTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
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
  var path_589101 = newJObject()
  var query_589102 = newJObject()
  var body_589103 = newJObject()
  add(query_589102, "upload_protocol", newJString(uploadProtocol))
  add(query_589102, "fields", newJString(fields))
  add(query_589102, "quotaUser", newJString(quotaUser))
  add(query_589102, "alt", newJString(alt))
  add(query_589102, "oauth_token", newJString(oauthToken))
  add(query_589102, "callback", newJString(callback))
  add(query_589102, "access_token", newJString(accessToken))
  add(query_589102, "uploadType", newJString(uploadType))
  add(query_589102, "key", newJString(key))
  add(query_589102, "$.xgafv", newJString(Xgafv))
  add(path_589101, "resource", newJString(resource))
  if body != nil:
    body_589103 = body
  add(query_589102, "prettyPrint", newJBool(prettyPrint))
  result = call_589100.call(path_589101, query_589102, nil, nil, body_589103)

var pubsubProjectsTopicsTestIamPermissions* = Call_PubsubProjectsTopicsTestIamPermissions_589083(
    name: "pubsubProjectsTopicsTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com",
    route: "/v1beta2/{resource}:testIamPermissions",
    validator: validate_PubsubProjectsTopicsTestIamPermissions_589084, base: "/",
    url: url_PubsubProjectsTopicsTestIamPermissions_589085,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsGet_589104 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSubscriptionsGet_589106(protocol: Scheme; host: string;
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

proc validate_PubsubProjectsSubscriptionsGet_589105(path: JsonNode;
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
  var valid_589107 = path.getOrDefault("subscription")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "subscription", valid_589107
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
  var valid_589108 = query.getOrDefault("upload_protocol")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "upload_protocol", valid_589108
  var valid_589109 = query.getOrDefault("fields")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "fields", valid_589109
  var valid_589110 = query.getOrDefault("quotaUser")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "quotaUser", valid_589110
  var valid_589111 = query.getOrDefault("alt")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = newJString("json"))
  if valid_589111 != nil:
    section.add "alt", valid_589111
  var valid_589112 = query.getOrDefault("oauth_token")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "oauth_token", valid_589112
  var valid_589113 = query.getOrDefault("callback")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "callback", valid_589113
  var valid_589114 = query.getOrDefault("access_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "access_token", valid_589114
  var valid_589115 = query.getOrDefault("uploadType")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "uploadType", valid_589115
  var valid_589116 = query.getOrDefault("key")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "key", valid_589116
  var valid_589117 = query.getOrDefault("$.xgafv")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = newJString("1"))
  if valid_589117 != nil:
    section.add "$.xgafv", valid_589117
  var valid_589118 = query.getOrDefault("prettyPrint")
  valid_589118 = validateParameter(valid_589118, JBool, required = false,
                                 default = newJBool(true))
  if valid_589118 != nil:
    section.add "prettyPrint", valid_589118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589119: Call_PubsubProjectsSubscriptionsGet_589104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration details of a subscription.
  ## 
  let valid = call_589119.validator(path, query, header, formData, body)
  let scheme = call_589119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589119.url(scheme.get, call_589119.host, call_589119.base,
                         call_589119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589119, url, valid)

proc call*(call_589120: Call_PubsubProjectsSubscriptionsGet_589104;
          subscription: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## pubsubProjectsSubscriptionsGet
  ## Gets the configuration details of a subscription.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   subscription: string (required)
  ##               : The name of the subscription to get.
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
  var path_589121 = newJObject()
  var query_589122 = newJObject()
  add(query_589122, "upload_protocol", newJString(uploadProtocol))
  add(query_589122, "fields", newJString(fields))
  add(query_589122, "quotaUser", newJString(quotaUser))
  add(path_589121, "subscription", newJString(subscription))
  add(query_589122, "alt", newJString(alt))
  add(query_589122, "oauth_token", newJString(oauthToken))
  add(query_589122, "callback", newJString(callback))
  add(query_589122, "access_token", newJString(accessToken))
  add(query_589122, "uploadType", newJString(uploadType))
  add(query_589122, "key", newJString(key))
  add(query_589122, "$.xgafv", newJString(Xgafv))
  add(query_589122, "prettyPrint", newJBool(prettyPrint))
  result = call_589120.call(path_589121, query_589122, nil, nil, nil)

var pubsubProjectsSubscriptionsGet* = Call_PubsubProjectsSubscriptionsGet_589104(
    name: "pubsubProjectsSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1beta2/{subscription}",
    validator: validate_PubsubProjectsSubscriptionsGet_589105, base: "/",
    url: url_PubsubProjectsSubscriptionsGet_589106, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsDelete_589123 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSubscriptionsDelete_589125(protocol: Scheme; host: string;
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

proc validate_PubsubProjectsSubscriptionsDelete_589124(path: JsonNode;
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
  var valid_589126 = path.getOrDefault("subscription")
  valid_589126 = validateParameter(valid_589126, JString, required = true,
                                 default = nil)
  if valid_589126 != nil:
    section.add "subscription", valid_589126
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
  var valid_589127 = query.getOrDefault("upload_protocol")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "upload_protocol", valid_589127
  var valid_589128 = query.getOrDefault("fields")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "fields", valid_589128
  var valid_589129 = query.getOrDefault("quotaUser")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "quotaUser", valid_589129
  var valid_589130 = query.getOrDefault("alt")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = newJString("json"))
  if valid_589130 != nil:
    section.add "alt", valid_589130
  var valid_589131 = query.getOrDefault("oauth_token")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "oauth_token", valid_589131
  var valid_589132 = query.getOrDefault("callback")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "callback", valid_589132
  var valid_589133 = query.getOrDefault("access_token")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "access_token", valid_589133
  var valid_589134 = query.getOrDefault("uploadType")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "uploadType", valid_589134
  var valid_589135 = query.getOrDefault("key")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "key", valid_589135
  var valid_589136 = query.getOrDefault("$.xgafv")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = newJString("1"))
  if valid_589136 != nil:
    section.add "$.xgafv", valid_589136
  var valid_589137 = query.getOrDefault("prettyPrint")
  valid_589137 = validateParameter(valid_589137, JBool, required = false,
                                 default = newJBool(true))
  if valid_589137 != nil:
    section.add "prettyPrint", valid_589137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589138: Call_PubsubProjectsSubscriptionsDelete_589123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing subscription. All pending messages in the subscription
  ## are immediately dropped. Calls to `Pull` after deletion will return
  ## `NOT_FOUND`. After a subscription is deleted, a new one may be created with
  ## the same name, but the new one has no association with the old
  ## subscription, or its topic unless the same topic is specified.
  ## 
  let valid = call_589138.validator(path, query, header, formData, body)
  let scheme = call_589138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589138.url(scheme.get, call_589138.host, call_589138.base,
                         call_589138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589138, url, valid)

proc call*(call_589139: Call_PubsubProjectsSubscriptionsDelete_589123;
          subscription: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## pubsubProjectsSubscriptionsDelete
  ## Deletes an existing subscription. All pending messages in the subscription
  ## are immediately dropped. Calls to `Pull` after deletion will return
  ## `NOT_FOUND`. After a subscription is deleted, a new one may be created with
  ## the same name, but the new one has no association with the old
  ## subscription, or its topic unless the same topic is specified.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   subscription: string (required)
  ##               : The subscription to delete.
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
  var path_589140 = newJObject()
  var query_589141 = newJObject()
  add(query_589141, "upload_protocol", newJString(uploadProtocol))
  add(query_589141, "fields", newJString(fields))
  add(query_589141, "quotaUser", newJString(quotaUser))
  add(path_589140, "subscription", newJString(subscription))
  add(query_589141, "alt", newJString(alt))
  add(query_589141, "oauth_token", newJString(oauthToken))
  add(query_589141, "callback", newJString(callback))
  add(query_589141, "access_token", newJString(accessToken))
  add(query_589141, "uploadType", newJString(uploadType))
  add(query_589141, "key", newJString(key))
  add(query_589141, "$.xgafv", newJString(Xgafv))
  add(query_589141, "prettyPrint", newJBool(prettyPrint))
  result = call_589139.call(path_589140, query_589141, nil, nil, nil)

var pubsubProjectsSubscriptionsDelete* = Call_PubsubProjectsSubscriptionsDelete_589123(
    name: "pubsubProjectsSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com", route: "/v1beta2/{subscription}",
    validator: validate_PubsubProjectsSubscriptionsDelete_589124, base: "/",
    url: url_PubsubProjectsSubscriptionsDelete_589125, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsAcknowledge_589142 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSubscriptionsAcknowledge_589144(protocol: Scheme;
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

proc validate_PubsubProjectsSubscriptionsAcknowledge_589143(path: JsonNode;
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
  var valid_589145 = path.getOrDefault("subscription")
  valid_589145 = validateParameter(valid_589145, JString, required = true,
                                 default = nil)
  if valid_589145 != nil:
    section.add "subscription", valid_589145
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
  var valid_589146 = query.getOrDefault("upload_protocol")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "upload_protocol", valid_589146
  var valid_589147 = query.getOrDefault("fields")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "fields", valid_589147
  var valid_589148 = query.getOrDefault("quotaUser")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "quotaUser", valid_589148
  var valid_589149 = query.getOrDefault("alt")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = newJString("json"))
  if valid_589149 != nil:
    section.add "alt", valid_589149
  var valid_589150 = query.getOrDefault("oauth_token")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "oauth_token", valid_589150
  var valid_589151 = query.getOrDefault("callback")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "callback", valid_589151
  var valid_589152 = query.getOrDefault("access_token")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "access_token", valid_589152
  var valid_589153 = query.getOrDefault("uploadType")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "uploadType", valid_589153
  var valid_589154 = query.getOrDefault("key")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "key", valid_589154
  var valid_589155 = query.getOrDefault("$.xgafv")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = newJString("1"))
  if valid_589155 != nil:
    section.add "$.xgafv", valid_589155
  var valid_589156 = query.getOrDefault("prettyPrint")
  valid_589156 = validateParameter(valid_589156, JBool, required = false,
                                 default = newJBool(true))
  if valid_589156 != nil:
    section.add "prettyPrint", valid_589156
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

proc call*(call_589158: Call_PubsubProjectsSubscriptionsAcknowledge_589142;
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
  let valid = call_589158.validator(path, query, header, formData, body)
  let scheme = call_589158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589158.url(scheme.get, call_589158.host, call_589158.base,
                         call_589158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589158, url, valid)

proc call*(call_589159: Call_PubsubProjectsSubscriptionsAcknowledge_589142;
          subscription: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## pubsubProjectsSubscriptionsAcknowledge
  ## Acknowledges the messages associated with the `ack_ids` in the
  ## `AcknowledgeRequest`. The Pub/Sub system can remove the relevant messages
  ## from the subscription.
  ## 
  ## Acknowledging a message whose ack deadline has expired may succeed,
  ## but such a message may be redelivered later. Acknowledging a message more
  ## than once will not result in an error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   subscription: string (required)
  ##               : The subscription whose message is being acknowledged.
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
  var path_589160 = newJObject()
  var query_589161 = newJObject()
  var body_589162 = newJObject()
  add(query_589161, "upload_protocol", newJString(uploadProtocol))
  add(query_589161, "fields", newJString(fields))
  add(query_589161, "quotaUser", newJString(quotaUser))
  add(path_589160, "subscription", newJString(subscription))
  add(query_589161, "alt", newJString(alt))
  add(query_589161, "oauth_token", newJString(oauthToken))
  add(query_589161, "callback", newJString(callback))
  add(query_589161, "access_token", newJString(accessToken))
  add(query_589161, "uploadType", newJString(uploadType))
  add(query_589161, "key", newJString(key))
  add(query_589161, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589162 = body
  add(query_589161, "prettyPrint", newJBool(prettyPrint))
  result = call_589159.call(path_589160, query_589161, nil, nil, body_589162)

var pubsubProjectsSubscriptionsAcknowledge* = Call_PubsubProjectsSubscriptionsAcknowledge_589142(
    name: "pubsubProjectsSubscriptionsAcknowledge", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta2/{subscription}:acknowledge",
    validator: validate_PubsubProjectsSubscriptionsAcknowledge_589143, base: "/",
    url: url_PubsubProjectsSubscriptionsAcknowledge_589144,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsModifyAckDeadline_589163 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSubscriptionsModifyAckDeadline_589165(protocol: Scheme;
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

proc validate_PubsubProjectsSubscriptionsModifyAckDeadline_589164(path: JsonNode;
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
  var valid_589166 = path.getOrDefault("subscription")
  valid_589166 = validateParameter(valid_589166, JString, required = true,
                                 default = nil)
  if valid_589166 != nil:
    section.add "subscription", valid_589166
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
  var valid_589167 = query.getOrDefault("upload_protocol")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "upload_protocol", valid_589167
  var valid_589168 = query.getOrDefault("fields")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "fields", valid_589168
  var valid_589169 = query.getOrDefault("quotaUser")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "quotaUser", valid_589169
  var valid_589170 = query.getOrDefault("alt")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = newJString("json"))
  if valid_589170 != nil:
    section.add "alt", valid_589170
  var valid_589171 = query.getOrDefault("oauth_token")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "oauth_token", valid_589171
  var valid_589172 = query.getOrDefault("callback")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "callback", valid_589172
  var valid_589173 = query.getOrDefault("access_token")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "access_token", valid_589173
  var valid_589174 = query.getOrDefault("uploadType")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "uploadType", valid_589174
  var valid_589175 = query.getOrDefault("key")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "key", valid_589175
  var valid_589176 = query.getOrDefault("$.xgafv")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = newJString("1"))
  if valid_589176 != nil:
    section.add "$.xgafv", valid_589176
  var valid_589177 = query.getOrDefault("prettyPrint")
  valid_589177 = validateParameter(valid_589177, JBool, required = false,
                                 default = newJBool(true))
  if valid_589177 != nil:
    section.add "prettyPrint", valid_589177
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

proc call*(call_589179: Call_PubsubProjectsSubscriptionsModifyAckDeadline_589163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the ack deadline for a specific message. This method is useful
  ## to indicate that more time is needed to process a message by the
  ## subscriber, or to make the message available for redelivery if the
  ## processing was interrupted. Note that this does not modify the
  ## subscription-level `ackDeadlineSeconds` used for subsequent messages.
  ## 
  let valid = call_589179.validator(path, query, header, formData, body)
  let scheme = call_589179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589179.url(scheme.get, call_589179.host, call_589179.base,
                         call_589179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589179, url, valid)

proc call*(call_589180: Call_PubsubProjectsSubscriptionsModifyAckDeadline_589163;
          subscription: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## pubsubProjectsSubscriptionsModifyAckDeadline
  ## Modifies the ack deadline for a specific message. This method is useful
  ## to indicate that more time is needed to process a message by the
  ## subscriber, or to make the message available for redelivery if the
  ## processing was interrupted. Note that this does not modify the
  ## subscription-level `ackDeadlineSeconds` used for subsequent messages.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   subscription: string (required)
  ##               : The name of the subscription.
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
  var path_589181 = newJObject()
  var query_589182 = newJObject()
  var body_589183 = newJObject()
  add(query_589182, "upload_protocol", newJString(uploadProtocol))
  add(query_589182, "fields", newJString(fields))
  add(query_589182, "quotaUser", newJString(quotaUser))
  add(path_589181, "subscription", newJString(subscription))
  add(query_589182, "alt", newJString(alt))
  add(query_589182, "oauth_token", newJString(oauthToken))
  add(query_589182, "callback", newJString(callback))
  add(query_589182, "access_token", newJString(accessToken))
  add(query_589182, "uploadType", newJString(uploadType))
  add(query_589182, "key", newJString(key))
  add(query_589182, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589183 = body
  add(query_589182, "prettyPrint", newJBool(prettyPrint))
  result = call_589180.call(path_589181, query_589182, nil, nil, body_589183)

var pubsubProjectsSubscriptionsModifyAckDeadline* = Call_PubsubProjectsSubscriptionsModifyAckDeadline_589163(
    name: "pubsubProjectsSubscriptionsModifyAckDeadline",
    meth: HttpMethod.HttpPost, host: "pubsub.googleapis.com",
    route: "/v1beta2/{subscription}:modifyAckDeadline",
    validator: validate_PubsubProjectsSubscriptionsModifyAckDeadline_589164,
    base: "/", url: url_PubsubProjectsSubscriptionsModifyAckDeadline_589165,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsModifyPushConfig_589184 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSubscriptionsModifyPushConfig_589186(protocol: Scheme;
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

proc validate_PubsubProjectsSubscriptionsModifyPushConfig_589185(path: JsonNode;
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
  var valid_589187 = path.getOrDefault("subscription")
  valid_589187 = validateParameter(valid_589187, JString, required = true,
                                 default = nil)
  if valid_589187 != nil:
    section.add "subscription", valid_589187
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
  var valid_589188 = query.getOrDefault("upload_protocol")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "upload_protocol", valid_589188
  var valid_589189 = query.getOrDefault("fields")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "fields", valid_589189
  var valid_589190 = query.getOrDefault("quotaUser")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "quotaUser", valid_589190
  var valid_589191 = query.getOrDefault("alt")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = newJString("json"))
  if valid_589191 != nil:
    section.add "alt", valid_589191
  var valid_589192 = query.getOrDefault("oauth_token")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "oauth_token", valid_589192
  var valid_589193 = query.getOrDefault("callback")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "callback", valid_589193
  var valid_589194 = query.getOrDefault("access_token")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "access_token", valid_589194
  var valid_589195 = query.getOrDefault("uploadType")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "uploadType", valid_589195
  var valid_589196 = query.getOrDefault("key")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "key", valid_589196
  var valid_589197 = query.getOrDefault("$.xgafv")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = newJString("1"))
  if valid_589197 != nil:
    section.add "$.xgafv", valid_589197
  var valid_589198 = query.getOrDefault("prettyPrint")
  valid_589198 = validateParameter(valid_589198, JBool, required = false,
                                 default = newJBool(true))
  if valid_589198 != nil:
    section.add "prettyPrint", valid_589198
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

proc call*(call_589200: Call_PubsubProjectsSubscriptionsModifyPushConfig_589184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the `PushConfig` for a specified subscription.
  ## 
  ## This may be used to change a push subscription to a pull one (signified by
  ## an empty `PushConfig`) or vice versa, or change the endpoint URL and other
  ## attributes of a push subscription. Messages will accumulate for delivery
  ## continuously through the call regardless of changes to the `PushConfig`.
  ## 
  let valid = call_589200.validator(path, query, header, formData, body)
  let scheme = call_589200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589200.url(scheme.get, call_589200.host, call_589200.base,
                         call_589200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589200, url, valid)

proc call*(call_589201: Call_PubsubProjectsSubscriptionsModifyPushConfig_589184;
          subscription: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## pubsubProjectsSubscriptionsModifyPushConfig
  ## Modifies the `PushConfig` for a specified subscription.
  ## 
  ## This may be used to change a push subscription to a pull one (signified by
  ## an empty `PushConfig`) or vice versa, or change the endpoint URL and other
  ## attributes of a push subscription. Messages will accumulate for delivery
  ## continuously through the call regardless of changes to the `PushConfig`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   subscription: string (required)
  ##               : The name of the subscription.
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
  var path_589202 = newJObject()
  var query_589203 = newJObject()
  var body_589204 = newJObject()
  add(query_589203, "upload_protocol", newJString(uploadProtocol))
  add(query_589203, "fields", newJString(fields))
  add(query_589203, "quotaUser", newJString(quotaUser))
  add(path_589202, "subscription", newJString(subscription))
  add(query_589203, "alt", newJString(alt))
  add(query_589203, "oauth_token", newJString(oauthToken))
  add(query_589203, "callback", newJString(callback))
  add(query_589203, "access_token", newJString(accessToken))
  add(query_589203, "uploadType", newJString(uploadType))
  add(query_589203, "key", newJString(key))
  add(query_589203, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589204 = body
  add(query_589203, "prettyPrint", newJBool(prettyPrint))
  result = call_589201.call(path_589202, query_589203, nil, nil, body_589204)

var pubsubProjectsSubscriptionsModifyPushConfig* = Call_PubsubProjectsSubscriptionsModifyPushConfig_589184(
    name: "pubsubProjectsSubscriptionsModifyPushConfig",
    meth: HttpMethod.HttpPost, host: "pubsub.googleapis.com",
    route: "/v1beta2/{subscription}:modifyPushConfig",
    validator: validate_PubsubProjectsSubscriptionsModifyPushConfig_589185,
    base: "/", url: url_PubsubProjectsSubscriptionsModifyPushConfig_589186,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsPull_589205 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSubscriptionsPull_589207(protocol: Scheme; host: string;
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

proc validate_PubsubProjectsSubscriptionsPull_589206(path: JsonNode;
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
  var valid_589208 = path.getOrDefault("subscription")
  valid_589208 = validateParameter(valid_589208, JString, required = true,
                                 default = nil)
  if valid_589208 != nil:
    section.add "subscription", valid_589208
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
  var valid_589209 = query.getOrDefault("upload_protocol")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "upload_protocol", valid_589209
  var valid_589210 = query.getOrDefault("fields")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "fields", valid_589210
  var valid_589211 = query.getOrDefault("quotaUser")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "quotaUser", valid_589211
  var valid_589212 = query.getOrDefault("alt")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = newJString("json"))
  if valid_589212 != nil:
    section.add "alt", valid_589212
  var valid_589213 = query.getOrDefault("oauth_token")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "oauth_token", valid_589213
  var valid_589214 = query.getOrDefault("callback")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "callback", valid_589214
  var valid_589215 = query.getOrDefault("access_token")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "access_token", valid_589215
  var valid_589216 = query.getOrDefault("uploadType")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "uploadType", valid_589216
  var valid_589217 = query.getOrDefault("key")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "key", valid_589217
  var valid_589218 = query.getOrDefault("$.xgafv")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = newJString("1"))
  if valid_589218 != nil:
    section.add "$.xgafv", valid_589218
  var valid_589219 = query.getOrDefault("prettyPrint")
  valid_589219 = validateParameter(valid_589219, JBool, required = false,
                                 default = newJBool(true))
  if valid_589219 != nil:
    section.add "prettyPrint", valid_589219
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

proc call*(call_589221: Call_PubsubProjectsSubscriptionsPull_589205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pulls messages from the server. Returns an empty list if there are no
  ## messages available in the backlog. The server may return `UNAVAILABLE` if
  ## there are too many concurrent pull requests pending for the given
  ## subscription.
  ## 
  let valid = call_589221.validator(path, query, header, formData, body)
  let scheme = call_589221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589221.url(scheme.get, call_589221.host, call_589221.base,
                         call_589221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589221, url, valid)

proc call*(call_589222: Call_PubsubProjectsSubscriptionsPull_589205;
          subscription: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## pubsubProjectsSubscriptionsPull
  ## Pulls messages from the server. Returns an empty list if there are no
  ## messages available in the backlog. The server may return `UNAVAILABLE` if
  ## there are too many concurrent pull requests pending for the given
  ## subscription.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   subscription: string (required)
  ##               : The subscription from which messages should be pulled.
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
  var path_589223 = newJObject()
  var query_589224 = newJObject()
  var body_589225 = newJObject()
  add(query_589224, "upload_protocol", newJString(uploadProtocol))
  add(query_589224, "fields", newJString(fields))
  add(query_589224, "quotaUser", newJString(quotaUser))
  add(path_589223, "subscription", newJString(subscription))
  add(query_589224, "alt", newJString(alt))
  add(query_589224, "oauth_token", newJString(oauthToken))
  add(query_589224, "callback", newJString(callback))
  add(query_589224, "access_token", newJString(accessToken))
  add(query_589224, "uploadType", newJString(uploadType))
  add(query_589224, "key", newJString(key))
  add(query_589224, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589225 = body
  add(query_589224, "prettyPrint", newJBool(prettyPrint))
  result = call_589222.call(path_589223, query_589224, nil, nil, body_589225)

var pubsubProjectsSubscriptionsPull* = Call_PubsubProjectsSubscriptionsPull_589205(
    name: "pubsubProjectsSubscriptionsPull", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta2/{subscription}:pull",
    validator: validate_PubsubProjectsSubscriptionsPull_589206, base: "/",
    url: url_PubsubProjectsSubscriptionsPull_589207, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsGet_589226 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsGet_589228(protocol: Scheme; host: string; base: string;
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

proc validate_PubsubProjectsTopicsGet_589227(path: JsonNode; query: JsonNode;
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
  var valid_589229 = path.getOrDefault("topic")
  valid_589229 = validateParameter(valid_589229, JString, required = true,
                                 default = nil)
  if valid_589229 != nil:
    section.add "topic", valid_589229
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
  var valid_589230 = query.getOrDefault("upload_protocol")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "upload_protocol", valid_589230
  var valid_589231 = query.getOrDefault("fields")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "fields", valid_589231
  var valid_589232 = query.getOrDefault("quotaUser")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "quotaUser", valid_589232
  var valid_589233 = query.getOrDefault("alt")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = newJString("json"))
  if valid_589233 != nil:
    section.add "alt", valid_589233
  var valid_589234 = query.getOrDefault("oauth_token")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "oauth_token", valid_589234
  var valid_589235 = query.getOrDefault("callback")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "callback", valid_589235
  var valid_589236 = query.getOrDefault("access_token")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "access_token", valid_589236
  var valid_589237 = query.getOrDefault("uploadType")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "uploadType", valid_589237
  var valid_589238 = query.getOrDefault("key")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "key", valid_589238
  var valid_589239 = query.getOrDefault("$.xgafv")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = newJString("1"))
  if valid_589239 != nil:
    section.add "$.xgafv", valid_589239
  var valid_589240 = query.getOrDefault("prettyPrint")
  valid_589240 = validateParameter(valid_589240, JBool, required = false,
                                 default = newJBool(true))
  if valid_589240 != nil:
    section.add "prettyPrint", valid_589240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589241: Call_PubsubProjectsTopicsGet_589226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration of a topic.
  ## 
  let valid = call_589241.validator(path, query, header, formData, body)
  let scheme = call_589241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589241.url(scheme.get, call_589241.host, call_589241.base,
                         call_589241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589241, url, valid)

proc call*(call_589242: Call_PubsubProjectsTopicsGet_589226; topic: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## pubsubProjectsTopicsGet
  ## Gets the configuration of a topic.
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
  ##   topic: string (required)
  ##        : The name of the topic to get.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589243 = newJObject()
  var query_589244 = newJObject()
  add(query_589244, "upload_protocol", newJString(uploadProtocol))
  add(query_589244, "fields", newJString(fields))
  add(query_589244, "quotaUser", newJString(quotaUser))
  add(query_589244, "alt", newJString(alt))
  add(query_589244, "oauth_token", newJString(oauthToken))
  add(query_589244, "callback", newJString(callback))
  add(query_589244, "access_token", newJString(accessToken))
  add(query_589244, "uploadType", newJString(uploadType))
  add(query_589244, "key", newJString(key))
  add(path_589243, "topic", newJString(topic))
  add(query_589244, "$.xgafv", newJString(Xgafv))
  add(query_589244, "prettyPrint", newJBool(prettyPrint))
  result = call_589242.call(path_589243, query_589244, nil, nil, nil)

var pubsubProjectsTopicsGet* = Call_PubsubProjectsTopicsGet_589226(
    name: "pubsubProjectsTopicsGet", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1beta2/{topic}",
    validator: validate_PubsubProjectsTopicsGet_589227, base: "/",
    url: url_PubsubProjectsTopicsGet_589228, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsDelete_589245 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsDelete_589247(protocol: Scheme; host: string;
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

proc validate_PubsubProjectsTopicsDelete_589246(path: JsonNode; query: JsonNode;
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
  var valid_589248 = path.getOrDefault("topic")
  valid_589248 = validateParameter(valid_589248, JString, required = true,
                                 default = nil)
  if valid_589248 != nil:
    section.add "topic", valid_589248
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
  var valid_589249 = query.getOrDefault("upload_protocol")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "upload_protocol", valid_589249
  var valid_589250 = query.getOrDefault("fields")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "fields", valid_589250
  var valid_589251 = query.getOrDefault("quotaUser")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "quotaUser", valid_589251
  var valid_589252 = query.getOrDefault("alt")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = newJString("json"))
  if valid_589252 != nil:
    section.add "alt", valid_589252
  var valid_589253 = query.getOrDefault("oauth_token")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "oauth_token", valid_589253
  var valid_589254 = query.getOrDefault("callback")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "callback", valid_589254
  var valid_589255 = query.getOrDefault("access_token")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "access_token", valid_589255
  var valid_589256 = query.getOrDefault("uploadType")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "uploadType", valid_589256
  var valid_589257 = query.getOrDefault("key")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "key", valid_589257
  var valid_589258 = query.getOrDefault("$.xgafv")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = newJString("1"))
  if valid_589258 != nil:
    section.add "$.xgafv", valid_589258
  var valid_589259 = query.getOrDefault("prettyPrint")
  valid_589259 = validateParameter(valid_589259, JBool, required = false,
                                 default = newJBool(true))
  if valid_589259 != nil:
    section.add "prettyPrint", valid_589259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589260: Call_PubsubProjectsTopicsDelete_589245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the topic with the given name. Returns `NOT_FOUND` if the topic
  ## does not exist. After a topic is deleted, a new topic may be created with
  ## the same name; this is an entirely new topic with none of the old
  ## configuration or subscriptions. Existing subscriptions to this topic are
  ## not deleted, but their `topic` field is set to `_deleted-topic_`.
  ## 
  let valid = call_589260.validator(path, query, header, formData, body)
  let scheme = call_589260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589260.url(scheme.get, call_589260.host, call_589260.base,
                         call_589260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589260, url, valid)

proc call*(call_589261: Call_PubsubProjectsTopicsDelete_589245; topic: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## pubsubProjectsTopicsDelete
  ## Deletes the topic with the given name. Returns `NOT_FOUND` if the topic
  ## does not exist. After a topic is deleted, a new topic may be created with
  ## the same name; this is an entirely new topic with none of the old
  ## configuration or subscriptions. Existing subscriptions to this topic are
  ## not deleted, but their `topic` field is set to `_deleted-topic_`.
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
  ##   topic: string (required)
  ##        : Name of the topic to delete.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589262 = newJObject()
  var query_589263 = newJObject()
  add(query_589263, "upload_protocol", newJString(uploadProtocol))
  add(query_589263, "fields", newJString(fields))
  add(query_589263, "quotaUser", newJString(quotaUser))
  add(query_589263, "alt", newJString(alt))
  add(query_589263, "oauth_token", newJString(oauthToken))
  add(query_589263, "callback", newJString(callback))
  add(query_589263, "access_token", newJString(accessToken))
  add(query_589263, "uploadType", newJString(uploadType))
  add(query_589263, "key", newJString(key))
  add(path_589262, "topic", newJString(topic))
  add(query_589263, "$.xgafv", newJString(Xgafv))
  add(query_589263, "prettyPrint", newJBool(prettyPrint))
  result = call_589261.call(path_589262, query_589263, nil, nil, nil)

var pubsubProjectsTopicsDelete* = Call_PubsubProjectsTopicsDelete_589245(
    name: "pubsubProjectsTopicsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com", route: "/v1beta2/{topic}",
    validator: validate_PubsubProjectsTopicsDelete_589246, base: "/",
    url: url_PubsubProjectsTopicsDelete_589247, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsSubscriptionsList_589264 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsSubscriptionsList_589266(protocol: Scheme;
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

proc validate_PubsubProjectsTopicsSubscriptionsList_589265(path: JsonNode;
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
  var valid_589267 = path.getOrDefault("topic")
  valid_589267 = validateParameter(valid_589267, JString, required = true,
                                 default = nil)
  if valid_589267 != nil:
    section.add "topic", valid_589267
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value returned by the last `ListTopicSubscriptionsResponse`; indicates
  ## that this is a continuation of a prior `ListTopicSubscriptions` call, and
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
  ##           : Maximum number of subscription names to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589268 = query.getOrDefault("upload_protocol")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "upload_protocol", valid_589268
  var valid_589269 = query.getOrDefault("fields")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "fields", valid_589269
  var valid_589270 = query.getOrDefault("pageToken")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "pageToken", valid_589270
  var valid_589271 = query.getOrDefault("quotaUser")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "quotaUser", valid_589271
  var valid_589272 = query.getOrDefault("alt")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = newJString("json"))
  if valid_589272 != nil:
    section.add "alt", valid_589272
  var valid_589273 = query.getOrDefault("oauth_token")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "oauth_token", valid_589273
  var valid_589274 = query.getOrDefault("callback")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "callback", valid_589274
  var valid_589275 = query.getOrDefault("access_token")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "access_token", valid_589275
  var valid_589276 = query.getOrDefault("uploadType")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "uploadType", valid_589276
  var valid_589277 = query.getOrDefault("key")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "key", valid_589277
  var valid_589278 = query.getOrDefault("$.xgafv")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = newJString("1"))
  if valid_589278 != nil:
    section.add "$.xgafv", valid_589278
  var valid_589279 = query.getOrDefault("pageSize")
  valid_589279 = validateParameter(valid_589279, JInt, required = false, default = nil)
  if valid_589279 != nil:
    section.add "pageSize", valid_589279
  var valid_589280 = query.getOrDefault("prettyPrint")
  valid_589280 = validateParameter(valid_589280, JBool, required = false,
                                 default = newJBool(true))
  if valid_589280 != nil:
    section.add "prettyPrint", valid_589280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589281: Call_PubsubProjectsTopicsSubscriptionsList_589264;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the name of the subscriptions for this topic.
  ## 
  let valid = call_589281.validator(path, query, header, formData, body)
  let scheme = call_589281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589281.url(scheme.get, call_589281.host, call_589281.base,
                         call_589281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589281, url, valid)

proc call*(call_589282: Call_PubsubProjectsTopicsSubscriptionsList_589264;
          topic: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## pubsubProjectsTopicsSubscriptionsList
  ## Lists the name of the subscriptions for this topic.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last `ListTopicSubscriptionsResponse`; indicates
  ## that this is a continuation of a prior `ListTopicSubscriptions` call, and
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   topic: string (required)
  ##        : The name of the topic that subscriptions are attached to.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of subscription names to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589283 = newJObject()
  var query_589284 = newJObject()
  add(query_589284, "upload_protocol", newJString(uploadProtocol))
  add(query_589284, "fields", newJString(fields))
  add(query_589284, "pageToken", newJString(pageToken))
  add(query_589284, "quotaUser", newJString(quotaUser))
  add(query_589284, "alt", newJString(alt))
  add(query_589284, "oauth_token", newJString(oauthToken))
  add(query_589284, "callback", newJString(callback))
  add(query_589284, "access_token", newJString(accessToken))
  add(query_589284, "uploadType", newJString(uploadType))
  add(query_589284, "key", newJString(key))
  add(path_589283, "topic", newJString(topic))
  add(query_589284, "$.xgafv", newJString(Xgafv))
  add(query_589284, "pageSize", newJInt(pageSize))
  add(query_589284, "prettyPrint", newJBool(prettyPrint))
  result = call_589282.call(path_589283, query_589284, nil, nil, nil)

var pubsubProjectsTopicsSubscriptionsList* = Call_PubsubProjectsTopicsSubscriptionsList_589264(
    name: "pubsubProjectsTopicsSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1beta2/{topic}/subscriptions",
    validator: validate_PubsubProjectsTopicsSubscriptionsList_589265, base: "/",
    url: url_PubsubProjectsTopicsSubscriptionsList_589266, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsPublish_589285 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsPublish_589287(protocol: Scheme; host: string;
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

proc validate_PubsubProjectsTopicsPublish_589286(path: JsonNode; query: JsonNode;
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
  var valid_589288 = path.getOrDefault("topic")
  valid_589288 = validateParameter(valid_589288, JString, required = true,
                                 default = nil)
  if valid_589288 != nil:
    section.add "topic", valid_589288
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
  var valid_589289 = query.getOrDefault("upload_protocol")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "upload_protocol", valid_589289
  var valid_589290 = query.getOrDefault("fields")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "fields", valid_589290
  var valid_589291 = query.getOrDefault("quotaUser")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "quotaUser", valid_589291
  var valid_589292 = query.getOrDefault("alt")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = newJString("json"))
  if valid_589292 != nil:
    section.add "alt", valid_589292
  var valid_589293 = query.getOrDefault("oauth_token")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "oauth_token", valid_589293
  var valid_589294 = query.getOrDefault("callback")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "callback", valid_589294
  var valid_589295 = query.getOrDefault("access_token")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "access_token", valid_589295
  var valid_589296 = query.getOrDefault("uploadType")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "uploadType", valid_589296
  var valid_589297 = query.getOrDefault("key")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "key", valid_589297
  var valid_589298 = query.getOrDefault("$.xgafv")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = newJString("1"))
  if valid_589298 != nil:
    section.add "$.xgafv", valid_589298
  var valid_589299 = query.getOrDefault("prettyPrint")
  valid_589299 = validateParameter(valid_589299, JBool, required = false,
                                 default = newJBool(true))
  if valid_589299 != nil:
    section.add "prettyPrint", valid_589299
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

proc call*(call_589301: Call_PubsubProjectsTopicsPublish_589285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds one or more messages to the topic. Returns `NOT_FOUND` if the topic
  ## does not exist. The message payload must not be empty; it must contain
  ##  either a non-empty data field, or at least one attribute.
  ## 
  let valid = call_589301.validator(path, query, header, formData, body)
  let scheme = call_589301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589301.url(scheme.get, call_589301.host, call_589301.base,
                         call_589301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589301, url, valid)

proc call*(call_589302: Call_PubsubProjectsTopicsPublish_589285; topic: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## pubsubProjectsTopicsPublish
  ## Adds one or more messages to the topic. Returns `NOT_FOUND` if the topic
  ## does not exist. The message payload must not be empty; it must contain
  ##  either a non-empty data field, or at least one attribute.
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
  ##   topic: string (required)
  ##        : The messages in the request will be published on this topic.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589303 = newJObject()
  var query_589304 = newJObject()
  var body_589305 = newJObject()
  add(query_589304, "upload_protocol", newJString(uploadProtocol))
  add(query_589304, "fields", newJString(fields))
  add(query_589304, "quotaUser", newJString(quotaUser))
  add(query_589304, "alt", newJString(alt))
  add(query_589304, "oauth_token", newJString(oauthToken))
  add(query_589304, "callback", newJString(callback))
  add(query_589304, "access_token", newJString(accessToken))
  add(query_589304, "uploadType", newJString(uploadType))
  add(query_589304, "key", newJString(key))
  add(path_589303, "topic", newJString(topic))
  add(query_589304, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589305 = body
  add(query_589304, "prettyPrint", newJBool(prettyPrint))
  result = call_589302.call(path_589303, query_589304, nil, nil, body_589305)

var pubsubProjectsTopicsPublish* = Call_PubsubProjectsTopicsPublish_589285(
    name: "pubsubProjectsTopicsPublish", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta2/{topic}:publish",
    validator: validate_PubsubProjectsTopicsPublish_589286, base: "/",
    url: url_PubsubProjectsTopicsPublish_589287, schemes: {Scheme.Https})
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
