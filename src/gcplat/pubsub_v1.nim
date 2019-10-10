
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Pub/Sub
## version: v1
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
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsCreate_588711(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the given topic with the given name. See the
  ## <a href="https://cloud.google.com/pubsub/docs/admin#resource_names">
  ## resource name rules</a>.
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
  ## Creates the given topic with the given name. See the
  ## <a href="https://cloud.google.com/pubsub/docs/admin#resource_names">
  ## resource name rules</a>.
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
  ## Creates the given topic with the given name. See the
  ## <a href="https://cloud.google.com/pubsub/docs/admin#resource_names">
  ## resource name rules</a>.
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
    host: "pubsub.googleapis.com", route: "/v1/{name}",
    validator: validate_PubsubProjectsTopicsCreate_588711, base: "/",
    url: url_PubsubProjectsTopicsCreate_588712, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsPatch_589000 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsPatch_589002(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_PubsubProjectsTopicsPatch_589001(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing topic. Note that certain properties of a
  ## topic are not modifiable.
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
  var valid_589003 = path.getOrDefault("name")
  valid_589003 = validateParameter(valid_589003, JString, required = true,
                                 default = nil)
  if valid_589003 != nil:
    section.add "name", valid_589003
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
  var valid_589006 = query.getOrDefault("quotaUser")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "quotaUser", valid_589006
  var valid_589007 = query.getOrDefault("alt")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = newJString("json"))
  if valid_589007 != nil:
    section.add "alt", valid_589007
  var valid_589008 = query.getOrDefault("oauth_token")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "oauth_token", valid_589008
  var valid_589009 = query.getOrDefault("callback")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "callback", valid_589009
  var valid_589010 = query.getOrDefault("access_token")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "access_token", valid_589010
  var valid_589011 = query.getOrDefault("uploadType")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "uploadType", valid_589011
  var valid_589012 = query.getOrDefault("key")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "key", valid_589012
  var valid_589013 = query.getOrDefault("$.xgafv")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = newJString("1"))
  if valid_589013 != nil:
    section.add "$.xgafv", valid_589013
  var valid_589014 = query.getOrDefault("prettyPrint")
  valid_589014 = validateParameter(valid_589014, JBool, required = false,
                                 default = newJBool(true))
  if valid_589014 != nil:
    section.add "prettyPrint", valid_589014
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

proc call*(call_589016: Call_PubsubProjectsTopicsPatch_589000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing topic. Note that certain properties of a
  ## topic are not modifiable.
  ## 
  let valid = call_589016.validator(path, query, header, formData, body)
  let scheme = call_589016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589016.url(scheme.get, call_589016.host, call_589016.base,
                         call_589016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589016, url, valid)

proc call*(call_589017: Call_PubsubProjectsTopicsPatch_589000; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## pubsubProjectsTopicsPatch
  ## Updates an existing topic. Note that certain properties of a
  ## topic are not modifiable.
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
  var path_589018 = newJObject()
  var query_589019 = newJObject()
  var body_589020 = newJObject()
  add(query_589019, "upload_protocol", newJString(uploadProtocol))
  add(query_589019, "fields", newJString(fields))
  add(query_589019, "quotaUser", newJString(quotaUser))
  add(path_589018, "name", newJString(name))
  add(query_589019, "alt", newJString(alt))
  add(query_589019, "oauth_token", newJString(oauthToken))
  add(query_589019, "callback", newJString(callback))
  add(query_589019, "access_token", newJString(accessToken))
  add(query_589019, "uploadType", newJString(uploadType))
  add(query_589019, "key", newJString(key))
  add(query_589019, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589020 = body
  add(query_589019, "prettyPrint", newJBool(prettyPrint))
  result = call_589017.call(path_589018, query_589019, nil, nil, body_589020)

var pubsubProjectsTopicsPatch* = Call_PubsubProjectsTopicsPatch_589000(
    name: "pubsubProjectsTopicsPatch", meth: HttpMethod.HttpPatch,
    host: "pubsub.googleapis.com", route: "/v1/{name}",
    validator: validate_PubsubProjectsTopicsPatch_589001, base: "/",
    url: url_PubsubProjectsTopicsPatch_589002, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSnapshotsList_589021 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSnapshotsList_589023(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/snapshots")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSnapshotsList_589022(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the existing snapshots. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The name of the project in which to list snapshots.
  ## Format is `projects/{project-id}`.
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
  ##            : The value returned by the last `ListSnapshotsResponse`; indicates that this
  ## is a continuation of a prior `ListSnapshots` call, and that the system
  ## should return the next page of data.
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
  ##           : Maximum number of snapshots to return.
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

proc call*(call_589038: Call_PubsubProjectsSnapshotsList_589021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the existing snapshots. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.
  ## 
  let valid = call_589038.validator(path, query, header, formData, body)
  let scheme = call_589038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589038.url(scheme.get, call_589038.host, call_589038.base,
                         call_589038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589038, url, valid)

proc call*(call_589039: Call_PubsubProjectsSnapshotsList_589021; project: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## pubsubProjectsSnapshotsList
  ## Lists the existing snapshots. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last `ListSnapshotsResponse`; indicates that this
  ## is a continuation of a prior `ListSnapshots` call, and that the system
  ## should return the next page of data.
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
  ##           : Maximum number of snapshots to return.
  ##   project: string (required)
  ##          : The name of the project in which to list snapshots.
  ## Format is `projects/{project-id}`.
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

var pubsubProjectsSnapshotsList* = Call_PubsubProjectsSnapshotsList_589021(
    name: "pubsubProjectsSnapshotsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{project}/snapshots",
    validator: validate_PubsubProjectsSnapshotsList_589022, base: "/",
    url: url_PubsubProjectsSnapshotsList_589023, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsList_589042 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSubscriptionsList_589044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsList_589043(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists matching subscriptions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The name of the project in which to list subscriptions.
  ## Format is `projects/{project-id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_589045 = path.getOrDefault("project")
  valid_589045 = validateParameter(valid_589045, JString, required = true,
                                 default = nil)
  if valid_589045 != nil:
    section.add "project", valid_589045
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
  var valid_589048 = query.getOrDefault("pageToken")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "pageToken", valid_589048
  var valid_589049 = query.getOrDefault("quotaUser")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "quotaUser", valid_589049
  var valid_589050 = query.getOrDefault("alt")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = newJString("json"))
  if valid_589050 != nil:
    section.add "alt", valid_589050
  var valid_589051 = query.getOrDefault("oauth_token")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "oauth_token", valid_589051
  var valid_589052 = query.getOrDefault("callback")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "callback", valid_589052
  var valid_589053 = query.getOrDefault("access_token")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "access_token", valid_589053
  var valid_589054 = query.getOrDefault("uploadType")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "uploadType", valid_589054
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
  var valid_589057 = query.getOrDefault("pageSize")
  valid_589057 = validateParameter(valid_589057, JInt, required = false, default = nil)
  if valid_589057 != nil:
    section.add "pageSize", valid_589057
  var valid_589058 = query.getOrDefault("prettyPrint")
  valid_589058 = validateParameter(valid_589058, JBool, required = false,
                                 default = newJBool(true))
  if valid_589058 != nil:
    section.add "prettyPrint", valid_589058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589059: Call_PubsubProjectsSubscriptionsList_589042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists matching subscriptions.
  ## 
  let valid = call_589059.validator(path, query, header, formData, body)
  let scheme = call_589059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589059.url(scheme.get, call_589059.host, call_589059.base,
                         call_589059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589059, url, valid)

proc call*(call_589060: Call_PubsubProjectsSubscriptionsList_589042;
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
  ##          : The name of the project in which to list subscriptions.
  ## Format is `projects/{project-id}`.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589061 = newJObject()
  var query_589062 = newJObject()
  add(query_589062, "upload_protocol", newJString(uploadProtocol))
  add(query_589062, "fields", newJString(fields))
  add(query_589062, "pageToken", newJString(pageToken))
  add(query_589062, "quotaUser", newJString(quotaUser))
  add(query_589062, "alt", newJString(alt))
  add(query_589062, "oauth_token", newJString(oauthToken))
  add(query_589062, "callback", newJString(callback))
  add(query_589062, "access_token", newJString(accessToken))
  add(query_589062, "uploadType", newJString(uploadType))
  add(query_589062, "key", newJString(key))
  add(query_589062, "$.xgafv", newJString(Xgafv))
  add(query_589062, "pageSize", newJInt(pageSize))
  add(path_589061, "project", newJString(project))
  add(query_589062, "prettyPrint", newJBool(prettyPrint))
  result = call_589060.call(path_589061, query_589062, nil, nil, nil)

var pubsubProjectsSubscriptionsList* = Call_PubsubProjectsSubscriptionsList_589042(
    name: "pubsubProjectsSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{project}/subscriptions",
    validator: validate_PubsubProjectsSubscriptionsList_589043, base: "/",
    url: url_PubsubProjectsSubscriptionsList_589044, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsList_589063 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsList_589065(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/topics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsList_589064(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists matching topics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The name of the project in which to list topics.
  ## Format is `projects/{project-id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_589066 = path.getOrDefault("project")
  valid_589066 = validateParameter(valid_589066, JString, required = true,
                                 default = nil)
  if valid_589066 != nil:
    section.add "project", valid_589066
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
  var valid_589067 = query.getOrDefault("upload_protocol")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "upload_protocol", valid_589067
  var valid_589068 = query.getOrDefault("fields")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "fields", valid_589068
  var valid_589069 = query.getOrDefault("pageToken")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "pageToken", valid_589069
  var valid_589070 = query.getOrDefault("quotaUser")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "quotaUser", valid_589070
  var valid_589071 = query.getOrDefault("alt")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = newJString("json"))
  if valid_589071 != nil:
    section.add "alt", valid_589071
  var valid_589072 = query.getOrDefault("oauth_token")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "oauth_token", valid_589072
  var valid_589073 = query.getOrDefault("callback")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "callback", valid_589073
  var valid_589074 = query.getOrDefault("access_token")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "access_token", valid_589074
  var valid_589075 = query.getOrDefault("uploadType")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "uploadType", valid_589075
  var valid_589076 = query.getOrDefault("key")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "key", valid_589076
  var valid_589077 = query.getOrDefault("$.xgafv")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = newJString("1"))
  if valid_589077 != nil:
    section.add "$.xgafv", valid_589077
  var valid_589078 = query.getOrDefault("pageSize")
  valid_589078 = validateParameter(valid_589078, JInt, required = false, default = nil)
  if valid_589078 != nil:
    section.add "pageSize", valid_589078
  var valid_589079 = query.getOrDefault("prettyPrint")
  valid_589079 = validateParameter(valid_589079, JBool, required = false,
                                 default = newJBool(true))
  if valid_589079 != nil:
    section.add "prettyPrint", valid_589079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589080: Call_PubsubProjectsTopicsList_589063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists matching topics.
  ## 
  let valid = call_589080.validator(path, query, header, formData, body)
  let scheme = call_589080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589080.url(scheme.get, call_589080.host, call_589080.base,
                         call_589080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589080, url, valid)

proc call*(call_589081: Call_PubsubProjectsTopicsList_589063; project: string;
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
  ##          : The name of the project in which to list topics.
  ## Format is `projects/{project-id}`.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589082 = newJObject()
  var query_589083 = newJObject()
  add(query_589083, "upload_protocol", newJString(uploadProtocol))
  add(query_589083, "fields", newJString(fields))
  add(query_589083, "pageToken", newJString(pageToken))
  add(query_589083, "quotaUser", newJString(quotaUser))
  add(query_589083, "alt", newJString(alt))
  add(query_589083, "oauth_token", newJString(oauthToken))
  add(query_589083, "callback", newJString(callback))
  add(query_589083, "access_token", newJString(accessToken))
  add(query_589083, "uploadType", newJString(uploadType))
  add(query_589083, "key", newJString(key))
  add(query_589083, "$.xgafv", newJString(Xgafv))
  add(query_589083, "pageSize", newJInt(pageSize))
  add(path_589082, "project", newJString(project))
  add(query_589083, "prettyPrint", newJBool(prettyPrint))
  result = call_589081.call(path_589082, query_589083, nil, nil, nil)

var pubsubProjectsTopicsList* = Call_PubsubProjectsTopicsList_589063(
    name: "pubsubProjectsTopicsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{project}/topics",
    validator: validate_PubsubProjectsTopicsList_589064, base: "/",
    url: url_PubsubProjectsTopicsList_589065, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsGetIamPolicy_589084 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsGetIamPolicy_589086(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_PubsubProjectsTopicsGetIamPolicy_589085(path: JsonNode;
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
  var valid_589087 = path.getOrDefault("resource")
  valid_589087 = validateParameter(valid_589087, JString, required = true,
                                 default = nil)
  if valid_589087 != nil:
    section.add "resource", valid_589087
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
  var valid_589088 = query.getOrDefault("upload_protocol")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "upload_protocol", valid_589088
  var valid_589089 = query.getOrDefault("fields")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "fields", valid_589089
  var valid_589090 = query.getOrDefault("quotaUser")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "quotaUser", valid_589090
  var valid_589091 = query.getOrDefault("alt")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = newJString("json"))
  if valid_589091 != nil:
    section.add "alt", valid_589091
  var valid_589092 = query.getOrDefault("oauth_token")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "oauth_token", valid_589092
  var valid_589093 = query.getOrDefault("callback")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "callback", valid_589093
  var valid_589094 = query.getOrDefault("access_token")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "access_token", valid_589094
  var valid_589095 = query.getOrDefault("uploadType")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "uploadType", valid_589095
  var valid_589096 = query.getOrDefault("options.requestedPolicyVersion")
  valid_589096 = validateParameter(valid_589096, JInt, required = false, default = nil)
  if valid_589096 != nil:
    section.add "options.requestedPolicyVersion", valid_589096
  var valid_589097 = query.getOrDefault("key")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "key", valid_589097
  var valid_589098 = query.getOrDefault("$.xgafv")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = newJString("1"))
  if valid_589098 != nil:
    section.add "$.xgafv", valid_589098
  var valid_589099 = query.getOrDefault("prettyPrint")
  valid_589099 = validateParameter(valid_589099, JBool, required = false,
                                 default = newJBool(true))
  if valid_589099 != nil:
    section.add "prettyPrint", valid_589099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589100: Call_PubsubProjectsTopicsGetIamPolicy_589084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_589100.validator(path, query, header, formData, body)
  let scheme = call_589100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589100.url(scheme.get, call_589100.host, call_589100.base,
                         call_589100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589100, url, valid)

proc call*(call_589101: Call_PubsubProjectsTopicsGetIamPolicy_589084;
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
  var path_589102 = newJObject()
  var query_589103 = newJObject()
  add(query_589103, "upload_protocol", newJString(uploadProtocol))
  add(query_589103, "fields", newJString(fields))
  add(query_589103, "quotaUser", newJString(quotaUser))
  add(query_589103, "alt", newJString(alt))
  add(query_589103, "oauth_token", newJString(oauthToken))
  add(query_589103, "callback", newJString(callback))
  add(query_589103, "access_token", newJString(accessToken))
  add(query_589103, "uploadType", newJString(uploadType))
  add(query_589103, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_589103, "key", newJString(key))
  add(query_589103, "$.xgafv", newJString(Xgafv))
  add(path_589102, "resource", newJString(resource))
  add(query_589103, "prettyPrint", newJBool(prettyPrint))
  result = call_589101.call(path_589102, query_589103, nil, nil, nil)

var pubsubProjectsTopicsGetIamPolicy* = Call_PubsubProjectsTopicsGetIamPolicy_589084(
    name: "pubsubProjectsTopicsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_PubsubProjectsTopicsGetIamPolicy_589085, base: "/",
    url: url_PubsubProjectsTopicsGetIamPolicy_589086, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsSetIamPolicy_589104 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsSetIamPolicy_589106(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_PubsubProjectsTopicsSetIamPolicy_589105(path: JsonNode;
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
  var valid_589107 = path.getOrDefault("resource")
  valid_589107 = validateParameter(valid_589107, JString, required = true,
                                 default = nil)
  if valid_589107 != nil:
    section.add "resource", valid_589107
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589120: Call_PubsubProjectsTopicsSetIamPolicy_589104;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_589120.validator(path, query, header, formData, body)
  let scheme = call_589120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589120.url(scheme.get, call_589120.host, call_589120.base,
                         call_589120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589120, url, valid)

proc call*(call_589121: Call_PubsubProjectsTopicsSetIamPolicy_589104;
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
  var path_589122 = newJObject()
  var query_589123 = newJObject()
  var body_589124 = newJObject()
  add(query_589123, "upload_protocol", newJString(uploadProtocol))
  add(query_589123, "fields", newJString(fields))
  add(query_589123, "quotaUser", newJString(quotaUser))
  add(query_589123, "alt", newJString(alt))
  add(query_589123, "oauth_token", newJString(oauthToken))
  add(query_589123, "callback", newJString(callback))
  add(query_589123, "access_token", newJString(accessToken))
  add(query_589123, "uploadType", newJString(uploadType))
  add(query_589123, "key", newJString(key))
  add(query_589123, "$.xgafv", newJString(Xgafv))
  add(path_589122, "resource", newJString(resource))
  if body != nil:
    body_589124 = body
  add(query_589123, "prettyPrint", newJBool(prettyPrint))
  result = call_589121.call(path_589122, query_589123, nil, nil, body_589124)

var pubsubProjectsTopicsSetIamPolicy* = Call_PubsubProjectsTopicsSetIamPolicy_589104(
    name: "pubsubProjectsTopicsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_PubsubProjectsTopicsSetIamPolicy_589105, base: "/",
    url: url_PubsubProjectsTopicsSetIamPolicy_589106, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsTestIamPermissions_589125 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsTestIamPermissions_589127(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_PubsubProjectsTopicsTestIamPermissions_589126(path: JsonNode;
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
  var valid_589128 = path.getOrDefault("resource")
  valid_589128 = validateParameter(valid_589128, JString, required = true,
                                 default = nil)
  if valid_589128 != nil:
    section.add "resource", valid_589128
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
  var valid_589129 = query.getOrDefault("upload_protocol")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "upload_protocol", valid_589129
  var valid_589130 = query.getOrDefault("fields")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "fields", valid_589130
  var valid_589131 = query.getOrDefault("quotaUser")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "quotaUser", valid_589131
  var valid_589132 = query.getOrDefault("alt")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = newJString("json"))
  if valid_589132 != nil:
    section.add "alt", valid_589132
  var valid_589133 = query.getOrDefault("oauth_token")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "oauth_token", valid_589133
  var valid_589134 = query.getOrDefault("callback")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "callback", valid_589134
  var valid_589135 = query.getOrDefault("access_token")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "access_token", valid_589135
  var valid_589136 = query.getOrDefault("uploadType")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "uploadType", valid_589136
  var valid_589137 = query.getOrDefault("key")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "key", valid_589137
  var valid_589138 = query.getOrDefault("$.xgafv")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = newJString("1"))
  if valid_589138 != nil:
    section.add "$.xgafv", valid_589138
  var valid_589139 = query.getOrDefault("prettyPrint")
  valid_589139 = validateParameter(valid_589139, JBool, required = false,
                                 default = newJBool(true))
  if valid_589139 != nil:
    section.add "prettyPrint", valid_589139
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

proc call*(call_589141: Call_PubsubProjectsTopicsTestIamPermissions_589125;
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
  let valid = call_589141.validator(path, query, header, formData, body)
  let scheme = call_589141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589141.url(scheme.get, call_589141.host, call_589141.base,
                         call_589141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589141, url, valid)

proc call*(call_589142: Call_PubsubProjectsTopicsTestIamPermissions_589125;
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
  var path_589143 = newJObject()
  var query_589144 = newJObject()
  var body_589145 = newJObject()
  add(query_589144, "upload_protocol", newJString(uploadProtocol))
  add(query_589144, "fields", newJString(fields))
  add(query_589144, "quotaUser", newJString(quotaUser))
  add(query_589144, "alt", newJString(alt))
  add(query_589144, "oauth_token", newJString(oauthToken))
  add(query_589144, "callback", newJString(callback))
  add(query_589144, "access_token", newJString(accessToken))
  add(query_589144, "uploadType", newJString(uploadType))
  add(query_589144, "key", newJString(key))
  add(query_589144, "$.xgafv", newJString(Xgafv))
  add(path_589143, "resource", newJString(resource))
  if body != nil:
    body_589145 = body
  add(query_589144, "prettyPrint", newJBool(prettyPrint))
  result = call_589142.call(path_589143, query_589144, nil, nil, body_589145)

var pubsubProjectsTopicsTestIamPermissions* = Call_PubsubProjectsTopicsTestIamPermissions_589125(
    name: "pubsubProjectsTopicsTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{resource}:testIamPermissions",
    validator: validate_PubsubProjectsTopicsTestIamPermissions_589126, base: "/",
    url: url_PubsubProjectsTopicsTestIamPermissions_589127,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSnapshotsGet_589146 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSnapshotsGet_589148(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "snapshot" in path, "`snapshot` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "snapshot")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSnapshotsGet_589147(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the configuration details of a snapshot. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow you to manage message acknowledgments in bulk. That
  ## is, you can set the acknowledgment state of messages in an existing
  ## subscription to the state captured by a snapshot.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   snapshot: JString (required)
  ##           : The name of the snapshot to get.
  ## Format is `projects/{project}/snapshots/{snap}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `snapshot` field"
  var valid_589149 = path.getOrDefault("snapshot")
  valid_589149 = validateParameter(valid_589149, JString, required = true,
                                 default = nil)
  if valid_589149 != nil:
    section.add "snapshot", valid_589149
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
  var valid_589150 = query.getOrDefault("upload_protocol")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "upload_protocol", valid_589150
  var valid_589151 = query.getOrDefault("fields")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "fields", valid_589151
  var valid_589152 = query.getOrDefault("quotaUser")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "quotaUser", valid_589152
  var valid_589153 = query.getOrDefault("alt")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = newJString("json"))
  if valid_589153 != nil:
    section.add "alt", valid_589153
  var valid_589154 = query.getOrDefault("oauth_token")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "oauth_token", valid_589154
  var valid_589155 = query.getOrDefault("callback")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "callback", valid_589155
  var valid_589156 = query.getOrDefault("access_token")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "access_token", valid_589156
  var valid_589157 = query.getOrDefault("uploadType")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "uploadType", valid_589157
  var valid_589158 = query.getOrDefault("key")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "key", valid_589158
  var valid_589159 = query.getOrDefault("$.xgafv")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = newJString("1"))
  if valid_589159 != nil:
    section.add "$.xgafv", valid_589159
  var valid_589160 = query.getOrDefault("prettyPrint")
  valid_589160 = validateParameter(valid_589160, JBool, required = false,
                                 default = newJBool(true))
  if valid_589160 != nil:
    section.add "prettyPrint", valid_589160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589161: Call_PubsubProjectsSnapshotsGet_589146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration details of a snapshot. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow you to manage message acknowledgments in bulk. That
  ## is, you can set the acknowledgment state of messages in an existing
  ## subscription to the state captured by a snapshot.
  ## 
  let valid = call_589161.validator(path, query, header, formData, body)
  let scheme = call_589161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589161.url(scheme.get, call_589161.host, call_589161.base,
                         call_589161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589161, url, valid)

proc call*(call_589162: Call_PubsubProjectsSnapshotsGet_589146; snapshot: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## pubsubProjectsSnapshotsGet
  ## Gets the configuration details of a snapshot. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow you to manage message acknowledgments in bulk. That
  ## is, you can set the acknowledgment state of messages in an existing
  ## subscription to the state captured by a snapshot.
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
  ##   snapshot: string (required)
  ##           : The name of the snapshot to get.
  ## Format is `projects/{project}/snapshots/{snap}`.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589163 = newJObject()
  var query_589164 = newJObject()
  add(query_589164, "upload_protocol", newJString(uploadProtocol))
  add(query_589164, "fields", newJString(fields))
  add(query_589164, "quotaUser", newJString(quotaUser))
  add(query_589164, "alt", newJString(alt))
  add(query_589164, "oauth_token", newJString(oauthToken))
  add(query_589164, "callback", newJString(callback))
  add(query_589164, "access_token", newJString(accessToken))
  add(query_589164, "uploadType", newJString(uploadType))
  add(query_589164, "key", newJString(key))
  add(query_589164, "$.xgafv", newJString(Xgafv))
  add(path_589163, "snapshot", newJString(snapshot))
  add(query_589164, "prettyPrint", newJBool(prettyPrint))
  result = call_589162.call(path_589163, query_589164, nil, nil, nil)

var pubsubProjectsSnapshotsGet* = Call_PubsubProjectsSnapshotsGet_589146(
    name: "pubsubProjectsSnapshotsGet", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{snapshot}",
    validator: validate_PubsubProjectsSnapshotsGet_589147, base: "/",
    url: url_PubsubProjectsSnapshotsGet_589148, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSnapshotsDelete_589165 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSnapshotsDelete_589167(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "snapshot" in path, "`snapshot` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "snapshot")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSnapshotsDelete_589166(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes an existing snapshot. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.<br><br>
  ## When the snapshot is deleted, all messages retained in the snapshot
  ## are immediately dropped. After a snapshot is deleted, a new one may be
  ## created with the same name, but the new one has no association with the old
  ## snapshot or its subscription, unless the same subscription is specified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   snapshot: JString (required)
  ##           : The name of the snapshot to delete.
  ## Format is `projects/{project}/snapshots/{snap}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `snapshot` field"
  var valid_589168 = path.getOrDefault("snapshot")
  valid_589168 = validateParameter(valid_589168, JString, required = true,
                                 default = nil)
  if valid_589168 != nil:
    section.add "snapshot", valid_589168
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
  var valid_589169 = query.getOrDefault("upload_protocol")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "upload_protocol", valid_589169
  var valid_589170 = query.getOrDefault("fields")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "fields", valid_589170
  var valid_589171 = query.getOrDefault("quotaUser")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "quotaUser", valid_589171
  var valid_589172 = query.getOrDefault("alt")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = newJString("json"))
  if valid_589172 != nil:
    section.add "alt", valid_589172
  var valid_589173 = query.getOrDefault("oauth_token")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "oauth_token", valid_589173
  var valid_589174 = query.getOrDefault("callback")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "callback", valid_589174
  var valid_589175 = query.getOrDefault("access_token")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "access_token", valid_589175
  var valid_589176 = query.getOrDefault("uploadType")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "uploadType", valid_589176
  var valid_589177 = query.getOrDefault("key")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "key", valid_589177
  var valid_589178 = query.getOrDefault("$.xgafv")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = newJString("1"))
  if valid_589178 != nil:
    section.add "$.xgafv", valid_589178
  var valid_589179 = query.getOrDefault("prettyPrint")
  valid_589179 = validateParameter(valid_589179, JBool, required = false,
                                 default = newJBool(true))
  if valid_589179 != nil:
    section.add "prettyPrint", valid_589179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589180: Call_PubsubProjectsSnapshotsDelete_589165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes an existing snapshot. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.<br><br>
  ## When the snapshot is deleted, all messages retained in the snapshot
  ## are immediately dropped. After a snapshot is deleted, a new one may be
  ## created with the same name, but the new one has no association with the old
  ## snapshot or its subscription, unless the same subscription is specified.
  ## 
  let valid = call_589180.validator(path, query, header, formData, body)
  let scheme = call_589180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589180.url(scheme.get, call_589180.host, call_589180.base,
                         call_589180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589180, url, valid)

proc call*(call_589181: Call_PubsubProjectsSnapshotsDelete_589165;
          snapshot: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## pubsubProjectsSnapshotsDelete
  ## Removes an existing snapshot. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.<br><br>
  ## When the snapshot is deleted, all messages retained in the snapshot
  ## are immediately dropped. After a snapshot is deleted, a new one may be
  ## created with the same name, but the new one has no association with the old
  ## snapshot or its subscription, unless the same subscription is specified.
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
  ##   snapshot: string (required)
  ##           : The name of the snapshot to delete.
  ## Format is `projects/{project}/snapshots/{snap}`.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589182 = newJObject()
  var query_589183 = newJObject()
  add(query_589183, "upload_protocol", newJString(uploadProtocol))
  add(query_589183, "fields", newJString(fields))
  add(query_589183, "quotaUser", newJString(quotaUser))
  add(query_589183, "alt", newJString(alt))
  add(query_589183, "oauth_token", newJString(oauthToken))
  add(query_589183, "callback", newJString(callback))
  add(query_589183, "access_token", newJString(accessToken))
  add(query_589183, "uploadType", newJString(uploadType))
  add(query_589183, "key", newJString(key))
  add(query_589183, "$.xgafv", newJString(Xgafv))
  add(path_589182, "snapshot", newJString(snapshot))
  add(query_589183, "prettyPrint", newJBool(prettyPrint))
  result = call_589181.call(path_589182, query_589183, nil, nil, nil)

var pubsubProjectsSnapshotsDelete* = Call_PubsubProjectsSnapshotsDelete_589165(
    name: "pubsubProjectsSnapshotsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com", route: "/v1/{snapshot}",
    validator: validate_PubsubProjectsSnapshotsDelete_589166, base: "/",
    url: url_PubsubProjectsSnapshotsDelete_589167, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsGet_589184 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSubscriptionsGet_589186(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "subscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsGet_589185(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the configuration details of a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The name of the subscription to get.
  ## Format is `projects/{project}/subscriptions/{sub}`.
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
  if body != nil:
    result.add "body", body

proc call*(call_589199: Call_PubsubProjectsSubscriptionsGet_589184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration details of a subscription.
  ## 
  let valid = call_589199.validator(path, query, header, formData, body)
  let scheme = call_589199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589199.url(scheme.get, call_589199.host, call_589199.base,
                         call_589199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589199, url, valid)

proc call*(call_589200: Call_PubsubProjectsSubscriptionsGet_589184;
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
  ## Format is `projects/{project}/subscriptions/{sub}`.
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
  var path_589201 = newJObject()
  var query_589202 = newJObject()
  add(query_589202, "upload_protocol", newJString(uploadProtocol))
  add(query_589202, "fields", newJString(fields))
  add(query_589202, "quotaUser", newJString(quotaUser))
  add(path_589201, "subscription", newJString(subscription))
  add(query_589202, "alt", newJString(alt))
  add(query_589202, "oauth_token", newJString(oauthToken))
  add(query_589202, "callback", newJString(callback))
  add(query_589202, "access_token", newJString(accessToken))
  add(query_589202, "uploadType", newJString(uploadType))
  add(query_589202, "key", newJString(key))
  add(query_589202, "$.xgafv", newJString(Xgafv))
  add(query_589202, "prettyPrint", newJBool(prettyPrint))
  result = call_589200.call(path_589201, query_589202, nil, nil, nil)

var pubsubProjectsSubscriptionsGet* = Call_PubsubProjectsSubscriptionsGet_589184(
    name: "pubsubProjectsSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{subscription}",
    validator: validate_PubsubProjectsSubscriptionsGet_589185, base: "/",
    url: url_PubsubProjectsSubscriptionsGet_589186, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsDelete_589203 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSubscriptionsDelete_589205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "subscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsDelete_589204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing subscription. All messages retained in the subscription
  ## are immediately dropped. Calls to `Pull` after deletion will return
  ## `NOT_FOUND`. After a subscription is deleted, a new one may be created with
  ## the same name, but the new one has no association with the old
  ## subscription or its topic unless the same topic is specified.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The subscription to delete.
  ## Format is `projects/{project}/subscriptions/{sub}`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_589206 = path.getOrDefault("subscription")
  valid_589206 = validateParameter(valid_589206, JString, required = true,
                                 default = nil)
  if valid_589206 != nil:
    section.add "subscription", valid_589206
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
  var valid_589207 = query.getOrDefault("upload_protocol")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "upload_protocol", valid_589207
  var valid_589208 = query.getOrDefault("fields")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "fields", valid_589208
  var valid_589209 = query.getOrDefault("quotaUser")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "quotaUser", valid_589209
  var valid_589210 = query.getOrDefault("alt")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = newJString("json"))
  if valid_589210 != nil:
    section.add "alt", valid_589210
  var valid_589211 = query.getOrDefault("oauth_token")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "oauth_token", valid_589211
  var valid_589212 = query.getOrDefault("callback")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "callback", valid_589212
  var valid_589213 = query.getOrDefault("access_token")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "access_token", valid_589213
  var valid_589214 = query.getOrDefault("uploadType")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "uploadType", valid_589214
  var valid_589215 = query.getOrDefault("key")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "key", valid_589215
  var valid_589216 = query.getOrDefault("$.xgafv")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = newJString("1"))
  if valid_589216 != nil:
    section.add "$.xgafv", valid_589216
  var valid_589217 = query.getOrDefault("prettyPrint")
  valid_589217 = validateParameter(valid_589217, JBool, required = false,
                                 default = newJBool(true))
  if valid_589217 != nil:
    section.add "prettyPrint", valid_589217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589218: Call_PubsubProjectsSubscriptionsDelete_589203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing subscription. All messages retained in the subscription
  ## are immediately dropped. Calls to `Pull` after deletion will return
  ## `NOT_FOUND`. After a subscription is deleted, a new one may be created with
  ## the same name, but the new one has no association with the old
  ## subscription or its topic unless the same topic is specified.
  ## 
  let valid = call_589218.validator(path, query, header, formData, body)
  let scheme = call_589218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589218.url(scheme.get, call_589218.host, call_589218.base,
                         call_589218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589218, url, valid)

proc call*(call_589219: Call_PubsubProjectsSubscriptionsDelete_589203;
          subscription: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## pubsubProjectsSubscriptionsDelete
  ## Deletes an existing subscription. All messages retained in the subscription
  ## are immediately dropped. Calls to `Pull` after deletion will return
  ## `NOT_FOUND`. After a subscription is deleted, a new one may be created with
  ## the same name, but the new one has no association with the old
  ## subscription or its topic unless the same topic is specified.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   subscription: string (required)
  ##               : The subscription to delete.
  ## Format is `projects/{project}/subscriptions/{sub}`.
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
  var path_589220 = newJObject()
  var query_589221 = newJObject()
  add(query_589221, "upload_protocol", newJString(uploadProtocol))
  add(query_589221, "fields", newJString(fields))
  add(query_589221, "quotaUser", newJString(quotaUser))
  add(path_589220, "subscription", newJString(subscription))
  add(query_589221, "alt", newJString(alt))
  add(query_589221, "oauth_token", newJString(oauthToken))
  add(query_589221, "callback", newJString(callback))
  add(query_589221, "access_token", newJString(accessToken))
  add(query_589221, "uploadType", newJString(uploadType))
  add(query_589221, "key", newJString(key))
  add(query_589221, "$.xgafv", newJString(Xgafv))
  add(query_589221, "prettyPrint", newJBool(prettyPrint))
  result = call_589219.call(path_589220, query_589221, nil, nil, nil)

var pubsubProjectsSubscriptionsDelete* = Call_PubsubProjectsSubscriptionsDelete_589203(
    name: "pubsubProjectsSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com", route: "/v1/{subscription}",
    validator: validate_PubsubProjectsSubscriptionsDelete_589204, base: "/",
    url: url_PubsubProjectsSubscriptionsDelete_589205, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsAcknowledge_589222 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSubscriptionsAcknowledge_589224(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "subscription"),
               (kind: ConstantSegment, value: ":acknowledge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsAcknowledge_589223(path: JsonNode;
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
  ## Format is `projects/{project}/subscriptions/{sub}`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_589225 = path.getOrDefault("subscription")
  valid_589225 = validateParameter(valid_589225, JString, required = true,
                                 default = nil)
  if valid_589225 != nil:
    section.add "subscription", valid_589225
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
  var valid_589226 = query.getOrDefault("upload_protocol")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "upload_protocol", valid_589226
  var valid_589227 = query.getOrDefault("fields")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "fields", valid_589227
  var valid_589228 = query.getOrDefault("quotaUser")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "quotaUser", valid_589228
  var valid_589229 = query.getOrDefault("alt")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = newJString("json"))
  if valid_589229 != nil:
    section.add "alt", valid_589229
  var valid_589230 = query.getOrDefault("oauth_token")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "oauth_token", valid_589230
  var valid_589231 = query.getOrDefault("callback")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "callback", valid_589231
  var valid_589232 = query.getOrDefault("access_token")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "access_token", valid_589232
  var valid_589233 = query.getOrDefault("uploadType")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "uploadType", valid_589233
  var valid_589234 = query.getOrDefault("key")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "key", valid_589234
  var valid_589235 = query.getOrDefault("$.xgafv")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = newJString("1"))
  if valid_589235 != nil:
    section.add "$.xgafv", valid_589235
  var valid_589236 = query.getOrDefault("prettyPrint")
  valid_589236 = validateParameter(valid_589236, JBool, required = false,
                                 default = newJBool(true))
  if valid_589236 != nil:
    section.add "prettyPrint", valid_589236
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

proc call*(call_589238: Call_PubsubProjectsSubscriptionsAcknowledge_589222;
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
  let valid = call_589238.validator(path, query, header, formData, body)
  let scheme = call_589238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589238.url(scheme.get, call_589238.host, call_589238.base,
                         call_589238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589238, url, valid)

proc call*(call_589239: Call_PubsubProjectsSubscriptionsAcknowledge_589222;
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
  ## Format is `projects/{project}/subscriptions/{sub}`.
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
  var path_589240 = newJObject()
  var query_589241 = newJObject()
  var body_589242 = newJObject()
  add(query_589241, "upload_protocol", newJString(uploadProtocol))
  add(query_589241, "fields", newJString(fields))
  add(query_589241, "quotaUser", newJString(quotaUser))
  add(path_589240, "subscription", newJString(subscription))
  add(query_589241, "alt", newJString(alt))
  add(query_589241, "oauth_token", newJString(oauthToken))
  add(query_589241, "callback", newJString(callback))
  add(query_589241, "access_token", newJString(accessToken))
  add(query_589241, "uploadType", newJString(uploadType))
  add(query_589241, "key", newJString(key))
  add(query_589241, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589242 = body
  add(query_589241, "prettyPrint", newJBool(prettyPrint))
  result = call_589239.call(path_589240, query_589241, nil, nil, body_589242)

var pubsubProjectsSubscriptionsAcknowledge* = Call_PubsubProjectsSubscriptionsAcknowledge_589222(
    name: "pubsubProjectsSubscriptionsAcknowledge", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{subscription}:acknowledge",
    validator: validate_PubsubProjectsSubscriptionsAcknowledge_589223, base: "/",
    url: url_PubsubProjectsSubscriptionsAcknowledge_589224,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsModifyAckDeadline_589243 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSubscriptionsModifyAckDeadline_589245(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "subscription"),
               (kind: ConstantSegment, value: ":modifyAckDeadline")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsModifyAckDeadline_589244(path: JsonNode;
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
  ## Format is `projects/{project}/subscriptions/{sub}`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_589246 = path.getOrDefault("subscription")
  valid_589246 = validateParameter(valid_589246, JString, required = true,
                                 default = nil)
  if valid_589246 != nil:
    section.add "subscription", valid_589246
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
  var valid_589247 = query.getOrDefault("upload_protocol")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "upload_protocol", valid_589247
  var valid_589248 = query.getOrDefault("fields")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "fields", valid_589248
  var valid_589249 = query.getOrDefault("quotaUser")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "quotaUser", valid_589249
  var valid_589250 = query.getOrDefault("alt")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = newJString("json"))
  if valid_589250 != nil:
    section.add "alt", valid_589250
  var valid_589251 = query.getOrDefault("oauth_token")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "oauth_token", valid_589251
  var valid_589252 = query.getOrDefault("callback")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "callback", valid_589252
  var valid_589253 = query.getOrDefault("access_token")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "access_token", valid_589253
  var valid_589254 = query.getOrDefault("uploadType")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "uploadType", valid_589254
  var valid_589255 = query.getOrDefault("key")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "key", valid_589255
  var valid_589256 = query.getOrDefault("$.xgafv")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = newJString("1"))
  if valid_589256 != nil:
    section.add "$.xgafv", valid_589256
  var valid_589257 = query.getOrDefault("prettyPrint")
  valid_589257 = validateParameter(valid_589257, JBool, required = false,
                                 default = newJBool(true))
  if valid_589257 != nil:
    section.add "prettyPrint", valid_589257
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

proc call*(call_589259: Call_PubsubProjectsSubscriptionsModifyAckDeadline_589243;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the ack deadline for a specific message. This method is useful
  ## to indicate that more time is needed to process a message by the
  ## subscriber, or to make the message available for redelivery if the
  ## processing was interrupted. Note that this does not modify the
  ## subscription-level `ackDeadlineSeconds` used for subsequent messages.
  ## 
  let valid = call_589259.validator(path, query, header, formData, body)
  let scheme = call_589259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589259.url(scheme.get, call_589259.host, call_589259.base,
                         call_589259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589259, url, valid)

proc call*(call_589260: Call_PubsubProjectsSubscriptionsModifyAckDeadline_589243;
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
  ## Format is `projects/{project}/subscriptions/{sub}`.
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
  var path_589261 = newJObject()
  var query_589262 = newJObject()
  var body_589263 = newJObject()
  add(query_589262, "upload_protocol", newJString(uploadProtocol))
  add(query_589262, "fields", newJString(fields))
  add(query_589262, "quotaUser", newJString(quotaUser))
  add(path_589261, "subscription", newJString(subscription))
  add(query_589262, "alt", newJString(alt))
  add(query_589262, "oauth_token", newJString(oauthToken))
  add(query_589262, "callback", newJString(callback))
  add(query_589262, "access_token", newJString(accessToken))
  add(query_589262, "uploadType", newJString(uploadType))
  add(query_589262, "key", newJString(key))
  add(query_589262, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589263 = body
  add(query_589262, "prettyPrint", newJBool(prettyPrint))
  result = call_589260.call(path_589261, query_589262, nil, nil, body_589263)

var pubsubProjectsSubscriptionsModifyAckDeadline* = Call_PubsubProjectsSubscriptionsModifyAckDeadline_589243(
    name: "pubsubProjectsSubscriptionsModifyAckDeadline",
    meth: HttpMethod.HttpPost, host: "pubsub.googleapis.com",
    route: "/v1/{subscription}:modifyAckDeadline",
    validator: validate_PubsubProjectsSubscriptionsModifyAckDeadline_589244,
    base: "/", url: url_PubsubProjectsSubscriptionsModifyAckDeadline_589245,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsModifyPushConfig_589264 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSubscriptionsModifyPushConfig_589266(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "subscription"),
               (kind: ConstantSegment, value: ":modifyPushConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsModifyPushConfig_589265(path: JsonNode;
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
  ## Format is `projects/{project}/subscriptions/{sub}`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_589267 = path.getOrDefault("subscription")
  valid_589267 = validateParameter(valid_589267, JString, required = true,
                                 default = nil)
  if valid_589267 != nil:
    section.add "subscription", valid_589267
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
  var valid_589270 = query.getOrDefault("quotaUser")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "quotaUser", valid_589270
  var valid_589271 = query.getOrDefault("alt")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = newJString("json"))
  if valid_589271 != nil:
    section.add "alt", valid_589271
  var valid_589272 = query.getOrDefault("oauth_token")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "oauth_token", valid_589272
  var valid_589273 = query.getOrDefault("callback")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "callback", valid_589273
  var valid_589274 = query.getOrDefault("access_token")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "access_token", valid_589274
  var valid_589275 = query.getOrDefault("uploadType")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "uploadType", valid_589275
  var valid_589276 = query.getOrDefault("key")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "key", valid_589276
  var valid_589277 = query.getOrDefault("$.xgafv")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = newJString("1"))
  if valid_589277 != nil:
    section.add "$.xgafv", valid_589277
  var valid_589278 = query.getOrDefault("prettyPrint")
  valid_589278 = validateParameter(valid_589278, JBool, required = false,
                                 default = newJBool(true))
  if valid_589278 != nil:
    section.add "prettyPrint", valid_589278
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

proc call*(call_589280: Call_PubsubProjectsSubscriptionsModifyPushConfig_589264;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the `PushConfig` for a specified subscription.
  ## 
  ## This may be used to change a push subscription to a pull one (signified by
  ## an empty `PushConfig`) or vice versa, or change the endpoint URL and other
  ## attributes of a push subscription. Messages will accumulate for delivery
  ## continuously through the call regardless of changes to the `PushConfig`.
  ## 
  let valid = call_589280.validator(path, query, header, formData, body)
  let scheme = call_589280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589280.url(scheme.get, call_589280.host, call_589280.base,
                         call_589280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589280, url, valid)

proc call*(call_589281: Call_PubsubProjectsSubscriptionsModifyPushConfig_589264;
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
  ## Format is `projects/{project}/subscriptions/{sub}`.
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
  var path_589282 = newJObject()
  var query_589283 = newJObject()
  var body_589284 = newJObject()
  add(query_589283, "upload_protocol", newJString(uploadProtocol))
  add(query_589283, "fields", newJString(fields))
  add(query_589283, "quotaUser", newJString(quotaUser))
  add(path_589282, "subscription", newJString(subscription))
  add(query_589283, "alt", newJString(alt))
  add(query_589283, "oauth_token", newJString(oauthToken))
  add(query_589283, "callback", newJString(callback))
  add(query_589283, "access_token", newJString(accessToken))
  add(query_589283, "uploadType", newJString(uploadType))
  add(query_589283, "key", newJString(key))
  add(query_589283, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589284 = body
  add(query_589283, "prettyPrint", newJBool(prettyPrint))
  result = call_589281.call(path_589282, query_589283, nil, nil, body_589284)

var pubsubProjectsSubscriptionsModifyPushConfig* = Call_PubsubProjectsSubscriptionsModifyPushConfig_589264(
    name: "pubsubProjectsSubscriptionsModifyPushConfig",
    meth: HttpMethod.HttpPost, host: "pubsub.googleapis.com",
    route: "/v1/{subscription}:modifyPushConfig",
    validator: validate_PubsubProjectsSubscriptionsModifyPushConfig_589265,
    base: "/", url: url_PubsubProjectsSubscriptionsModifyPushConfig_589266,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsPull_589285 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSubscriptionsPull_589287(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "subscription"),
               (kind: ConstantSegment, value: ":pull")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsPull_589286(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pulls messages from the server. The server may return `UNAVAILABLE` if
  ## there are too many concurrent pull requests pending for the given
  ## subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The subscription from which messages should be pulled.
  ## Format is `projects/{project}/subscriptions/{sub}`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_589288 = path.getOrDefault("subscription")
  valid_589288 = validateParameter(valid_589288, JString, required = true,
                                 default = nil)
  if valid_589288 != nil:
    section.add "subscription", valid_589288
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

proc call*(call_589301: Call_PubsubProjectsSubscriptionsPull_589285;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pulls messages from the server. The server may return `UNAVAILABLE` if
  ## there are too many concurrent pull requests pending for the given
  ## subscription.
  ## 
  let valid = call_589301.validator(path, query, header, formData, body)
  let scheme = call_589301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589301.url(scheme.get, call_589301.host, call_589301.base,
                         call_589301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589301, url, valid)

proc call*(call_589302: Call_PubsubProjectsSubscriptionsPull_589285;
          subscription: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## pubsubProjectsSubscriptionsPull
  ## Pulls messages from the server. The server may return `UNAVAILABLE` if
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
  ## Format is `projects/{project}/subscriptions/{sub}`.
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
  var path_589303 = newJObject()
  var query_589304 = newJObject()
  var body_589305 = newJObject()
  add(query_589304, "upload_protocol", newJString(uploadProtocol))
  add(query_589304, "fields", newJString(fields))
  add(query_589304, "quotaUser", newJString(quotaUser))
  add(path_589303, "subscription", newJString(subscription))
  add(query_589304, "alt", newJString(alt))
  add(query_589304, "oauth_token", newJString(oauthToken))
  add(query_589304, "callback", newJString(callback))
  add(query_589304, "access_token", newJString(accessToken))
  add(query_589304, "uploadType", newJString(uploadType))
  add(query_589304, "key", newJString(key))
  add(query_589304, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589305 = body
  add(query_589304, "prettyPrint", newJBool(prettyPrint))
  result = call_589302.call(path_589303, query_589304, nil, nil, body_589305)

var pubsubProjectsSubscriptionsPull* = Call_PubsubProjectsSubscriptionsPull_589285(
    name: "pubsubProjectsSubscriptionsPull", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{subscription}:pull",
    validator: validate_PubsubProjectsSubscriptionsPull_589286, base: "/",
    url: url_PubsubProjectsSubscriptionsPull_589287, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsSeek_589306 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsSubscriptionsSeek_589308(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "subscription"),
               (kind: ConstantSegment, value: ":seek")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsSeek_589307(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Seeks an existing subscription to a point in time or to a given snapshot,
  ## whichever is provided in the request. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot. Note that both the subscription and the snapshot
  ## must be on the same topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The subscription to affect.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_589309 = path.getOrDefault("subscription")
  valid_589309 = validateParameter(valid_589309, JString, required = true,
                                 default = nil)
  if valid_589309 != nil:
    section.add "subscription", valid_589309
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
  var valid_589310 = query.getOrDefault("upload_protocol")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "upload_protocol", valid_589310
  var valid_589311 = query.getOrDefault("fields")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "fields", valid_589311
  var valid_589312 = query.getOrDefault("quotaUser")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "quotaUser", valid_589312
  var valid_589313 = query.getOrDefault("alt")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = newJString("json"))
  if valid_589313 != nil:
    section.add "alt", valid_589313
  var valid_589314 = query.getOrDefault("oauth_token")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "oauth_token", valid_589314
  var valid_589315 = query.getOrDefault("callback")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "callback", valid_589315
  var valid_589316 = query.getOrDefault("access_token")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "access_token", valid_589316
  var valid_589317 = query.getOrDefault("uploadType")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "uploadType", valid_589317
  var valid_589318 = query.getOrDefault("key")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "key", valid_589318
  var valid_589319 = query.getOrDefault("$.xgafv")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = newJString("1"))
  if valid_589319 != nil:
    section.add "$.xgafv", valid_589319
  var valid_589320 = query.getOrDefault("prettyPrint")
  valid_589320 = validateParameter(valid_589320, JBool, required = false,
                                 default = newJBool(true))
  if valid_589320 != nil:
    section.add "prettyPrint", valid_589320
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

proc call*(call_589322: Call_PubsubProjectsSubscriptionsSeek_589306;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Seeks an existing subscription to a point in time or to a given snapshot,
  ## whichever is provided in the request. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot. Note that both the subscription and the snapshot
  ## must be on the same topic.
  ## 
  let valid = call_589322.validator(path, query, header, formData, body)
  let scheme = call_589322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589322.url(scheme.get, call_589322.host, call_589322.base,
                         call_589322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589322, url, valid)

proc call*(call_589323: Call_PubsubProjectsSubscriptionsSeek_589306;
          subscription: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## pubsubProjectsSubscriptionsSeek
  ## Seeks an existing subscription to a point in time or to a given snapshot,
  ## whichever is provided in the request. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot. Note that both the subscription and the snapshot
  ## must be on the same topic.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   subscription: string (required)
  ##               : The subscription to affect.
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
  var path_589324 = newJObject()
  var query_589325 = newJObject()
  var body_589326 = newJObject()
  add(query_589325, "upload_protocol", newJString(uploadProtocol))
  add(query_589325, "fields", newJString(fields))
  add(query_589325, "quotaUser", newJString(quotaUser))
  add(path_589324, "subscription", newJString(subscription))
  add(query_589325, "alt", newJString(alt))
  add(query_589325, "oauth_token", newJString(oauthToken))
  add(query_589325, "callback", newJString(callback))
  add(query_589325, "access_token", newJString(accessToken))
  add(query_589325, "uploadType", newJString(uploadType))
  add(query_589325, "key", newJString(key))
  add(query_589325, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589326 = body
  add(query_589325, "prettyPrint", newJBool(prettyPrint))
  result = call_589323.call(path_589324, query_589325, nil, nil, body_589326)

var pubsubProjectsSubscriptionsSeek* = Call_PubsubProjectsSubscriptionsSeek_589306(
    name: "pubsubProjectsSubscriptionsSeek", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{subscription}:seek",
    validator: validate_PubsubProjectsSubscriptionsSeek_589307, base: "/",
    url: url_PubsubProjectsSubscriptionsSeek_589308, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsGet_589327 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsGet_589329(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "topic")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsGet_589328(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the configuration of a topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topic: JString (required)
  ##        : The name of the topic to get.
  ## Format is `projects/{project}/topics/{topic}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `topic` field"
  var valid_589330 = path.getOrDefault("topic")
  valid_589330 = validateParameter(valid_589330, JString, required = true,
                                 default = nil)
  if valid_589330 != nil:
    section.add "topic", valid_589330
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
  var valid_589331 = query.getOrDefault("upload_protocol")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "upload_protocol", valid_589331
  var valid_589332 = query.getOrDefault("fields")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "fields", valid_589332
  var valid_589333 = query.getOrDefault("quotaUser")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "quotaUser", valid_589333
  var valid_589334 = query.getOrDefault("alt")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = newJString("json"))
  if valid_589334 != nil:
    section.add "alt", valid_589334
  var valid_589335 = query.getOrDefault("oauth_token")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "oauth_token", valid_589335
  var valid_589336 = query.getOrDefault("callback")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "callback", valid_589336
  var valid_589337 = query.getOrDefault("access_token")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "access_token", valid_589337
  var valid_589338 = query.getOrDefault("uploadType")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "uploadType", valid_589338
  var valid_589339 = query.getOrDefault("key")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "key", valid_589339
  var valid_589340 = query.getOrDefault("$.xgafv")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = newJString("1"))
  if valid_589340 != nil:
    section.add "$.xgafv", valid_589340
  var valid_589341 = query.getOrDefault("prettyPrint")
  valid_589341 = validateParameter(valid_589341, JBool, required = false,
                                 default = newJBool(true))
  if valid_589341 != nil:
    section.add "prettyPrint", valid_589341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589342: Call_PubsubProjectsTopicsGet_589327; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration of a topic.
  ## 
  let valid = call_589342.validator(path, query, header, formData, body)
  let scheme = call_589342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589342.url(scheme.get, call_589342.host, call_589342.base,
                         call_589342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589342, url, valid)

proc call*(call_589343: Call_PubsubProjectsTopicsGet_589327; topic: string;
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
  ## Format is `projects/{project}/topics/{topic}`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589344 = newJObject()
  var query_589345 = newJObject()
  add(query_589345, "upload_protocol", newJString(uploadProtocol))
  add(query_589345, "fields", newJString(fields))
  add(query_589345, "quotaUser", newJString(quotaUser))
  add(query_589345, "alt", newJString(alt))
  add(query_589345, "oauth_token", newJString(oauthToken))
  add(query_589345, "callback", newJString(callback))
  add(query_589345, "access_token", newJString(accessToken))
  add(query_589345, "uploadType", newJString(uploadType))
  add(query_589345, "key", newJString(key))
  add(path_589344, "topic", newJString(topic))
  add(query_589345, "$.xgafv", newJString(Xgafv))
  add(query_589345, "prettyPrint", newJBool(prettyPrint))
  result = call_589343.call(path_589344, query_589345, nil, nil, nil)

var pubsubProjectsTopicsGet* = Call_PubsubProjectsTopicsGet_589327(
    name: "pubsubProjectsTopicsGet", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{topic}",
    validator: validate_PubsubProjectsTopicsGet_589328, base: "/",
    url: url_PubsubProjectsTopicsGet_589329, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsDelete_589346 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsDelete_589348(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "topic")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsDelete_589347(path: JsonNode; query: JsonNode;
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
  ## Format is `projects/{project}/topics/{topic}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `topic` field"
  var valid_589349 = path.getOrDefault("topic")
  valid_589349 = validateParameter(valid_589349, JString, required = true,
                                 default = nil)
  if valid_589349 != nil:
    section.add "topic", valid_589349
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
  var valid_589350 = query.getOrDefault("upload_protocol")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "upload_protocol", valid_589350
  var valid_589351 = query.getOrDefault("fields")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = nil)
  if valid_589351 != nil:
    section.add "fields", valid_589351
  var valid_589352 = query.getOrDefault("quotaUser")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "quotaUser", valid_589352
  var valid_589353 = query.getOrDefault("alt")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = newJString("json"))
  if valid_589353 != nil:
    section.add "alt", valid_589353
  var valid_589354 = query.getOrDefault("oauth_token")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "oauth_token", valid_589354
  var valid_589355 = query.getOrDefault("callback")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = nil)
  if valid_589355 != nil:
    section.add "callback", valid_589355
  var valid_589356 = query.getOrDefault("access_token")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "access_token", valid_589356
  var valid_589357 = query.getOrDefault("uploadType")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "uploadType", valid_589357
  var valid_589358 = query.getOrDefault("key")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "key", valid_589358
  var valid_589359 = query.getOrDefault("$.xgafv")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = newJString("1"))
  if valid_589359 != nil:
    section.add "$.xgafv", valid_589359
  var valid_589360 = query.getOrDefault("prettyPrint")
  valid_589360 = validateParameter(valid_589360, JBool, required = false,
                                 default = newJBool(true))
  if valid_589360 != nil:
    section.add "prettyPrint", valid_589360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589361: Call_PubsubProjectsTopicsDelete_589346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the topic with the given name. Returns `NOT_FOUND` if the topic
  ## does not exist. After a topic is deleted, a new topic may be created with
  ## the same name; this is an entirely new topic with none of the old
  ## configuration or subscriptions. Existing subscriptions to this topic are
  ## not deleted, but their `topic` field is set to `_deleted-topic_`.
  ## 
  let valid = call_589361.validator(path, query, header, formData, body)
  let scheme = call_589361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589361.url(scheme.get, call_589361.host, call_589361.base,
                         call_589361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589361, url, valid)

proc call*(call_589362: Call_PubsubProjectsTopicsDelete_589346; topic: string;
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
  ## Format is `projects/{project}/topics/{topic}`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589363 = newJObject()
  var query_589364 = newJObject()
  add(query_589364, "upload_protocol", newJString(uploadProtocol))
  add(query_589364, "fields", newJString(fields))
  add(query_589364, "quotaUser", newJString(quotaUser))
  add(query_589364, "alt", newJString(alt))
  add(query_589364, "oauth_token", newJString(oauthToken))
  add(query_589364, "callback", newJString(callback))
  add(query_589364, "access_token", newJString(accessToken))
  add(query_589364, "uploadType", newJString(uploadType))
  add(query_589364, "key", newJString(key))
  add(path_589363, "topic", newJString(topic))
  add(query_589364, "$.xgafv", newJString(Xgafv))
  add(query_589364, "prettyPrint", newJBool(prettyPrint))
  result = call_589362.call(path_589363, query_589364, nil, nil, nil)

var pubsubProjectsTopicsDelete* = Call_PubsubProjectsTopicsDelete_589346(
    name: "pubsubProjectsTopicsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com", route: "/v1/{topic}",
    validator: validate_PubsubProjectsTopicsDelete_589347, base: "/",
    url: url_PubsubProjectsTopicsDelete_589348, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsSnapshotsList_589365 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsSnapshotsList_589367(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "topic"),
               (kind: ConstantSegment, value: "/snapshots")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsSnapshotsList_589366(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the names of the snapshots on this topic. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topic: JString (required)
  ##        : The name of the topic that snapshots are attached to.
  ## Format is `projects/{project}/topics/{topic}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `topic` field"
  var valid_589368 = path.getOrDefault("topic")
  valid_589368 = validateParameter(valid_589368, JString, required = true,
                                 default = nil)
  if valid_589368 != nil:
    section.add "topic", valid_589368
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value returned by the last `ListTopicSnapshotsResponse`; indicates
  ## that this is a continuation of a prior `ListTopicSnapshots` call, and
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
  ##           : Maximum number of snapshot names to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589369 = query.getOrDefault("upload_protocol")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "upload_protocol", valid_589369
  var valid_589370 = query.getOrDefault("fields")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "fields", valid_589370
  var valid_589371 = query.getOrDefault("pageToken")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "pageToken", valid_589371
  var valid_589372 = query.getOrDefault("quotaUser")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "quotaUser", valid_589372
  var valid_589373 = query.getOrDefault("alt")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = newJString("json"))
  if valid_589373 != nil:
    section.add "alt", valid_589373
  var valid_589374 = query.getOrDefault("oauth_token")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "oauth_token", valid_589374
  var valid_589375 = query.getOrDefault("callback")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "callback", valid_589375
  var valid_589376 = query.getOrDefault("access_token")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "access_token", valid_589376
  var valid_589377 = query.getOrDefault("uploadType")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "uploadType", valid_589377
  var valid_589378 = query.getOrDefault("key")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "key", valid_589378
  var valid_589379 = query.getOrDefault("$.xgafv")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = newJString("1"))
  if valid_589379 != nil:
    section.add "$.xgafv", valid_589379
  var valid_589380 = query.getOrDefault("pageSize")
  valid_589380 = validateParameter(valid_589380, JInt, required = false, default = nil)
  if valid_589380 != nil:
    section.add "pageSize", valid_589380
  var valid_589381 = query.getOrDefault("prettyPrint")
  valid_589381 = validateParameter(valid_589381, JBool, required = false,
                                 default = newJBool(true))
  if valid_589381 != nil:
    section.add "prettyPrint", valid_589381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589382: Call_PubsubProjectsTopicsSnapshotsList_589365;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the names of the snapshots on this topic. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.
  ## 
  let valid = call_589382.validator(path, query, header, formData, body)
  let scheme = call_589382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589382.url(scheme.get, call_589382.host, call_589382.base,
                         call_589382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589382, url, valid)

proc call*(call_589383: Call_PubsubProjectsTopicsSnapshotsList_589365;
          topic: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## pubsubProjectsTopicsSnapshotsList
  ## Lists the names of the snapshots on this topic. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last `ListTopicSnapshotsResponse`; indicates
  ## that this is a continuation of a prior `ListTopicSnapshots` call, and
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
  ##        : The name of the topic that snapshots are attached to.
  ## Format is `projects/{project}/topics/{topic}`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of snapshot names to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589384 = newJObject()
  var query_589385 = newJObject()
  add(query_589385, "upload_protocol", newJString(uploadProtocol))
  add(query_589385, "fields", newJString(fields))
  add(query_589385, "pageToken", newJString(pageToken))
  add(query_589385, "quotaUser", newJString(quotaUser))
  add(query_589385, "alt", newJString(alt))
  add(query_589385, "oauth_token", newJString(oauthToken))
  add(query_589385, "callback", newJString(callback))
  add(query_589385, "access_token", newJString(accessToken))
  add(query_589385, "uploadType", newJString(uploadType))
  add(query_589385, "key", newJString(key))
  add(path_589384, "topic", newJString(topic))
  add(query_589385, "$.xgafv", newJString(Xgafv))
  add(query_589385, "pageSize", newJInt(pageSize))
  add(query_589385, "prettyPrint", newJBool(prettyPrint))
  result = call_589383.call(path_589384, query_589385, nil, nil, nil)

var pubsubProjectsTopicsSnapshotsList* = Call_PubsubProjectsTopicsSnapshotsList_589365(
    name: "pubsubProjectsTopicsSnapshotsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{topic}/snapshots",
    validator: validate_PubsubProjectsTopicsSnapshotsList_589366, base: "/",
    url: url_PubsubProjectsTopicsSnapshotsList_589367, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsSubscriptionsList_589386 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsSubscriptionsList_589388(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "topic"),
               (kind: ConstantSegment, value: "/subscriptions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsSubscriptionsList_589387(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the names of the subscriptions on this topic.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topic: JString (required)
  ##        : The name of the topic that subscriptions are attached to.
  ## Format is `projects/{project}/topics/{topic}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `topic` field"
  var valid_589389 = path.getOrDefault("topic")
  valid_589389 = validateParameter(valid_589389, JString, required = true,
                                 default = nil)
  if valid_589389 != nil:
    section.add "topic", valid_589389
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
  var valid_589390 = query.getOrDefault("upload_protocol")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "upload_protocol", valid_589390
  var valid_589391 = query.getOrDefault("fields")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "fields", valid_589391
  var valid_589392 = query.getOrDefault("pageToken")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "pageToken", valid_589392
  var valid_589393 = query.getOrDefault("quotaUser")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "quotaUser", valid_589393
  var valid_589394 = query.getOrDefault("alt")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = newJString("json"))
  if valid_589394 != nil:
    section.add "alt", valid_589394
  var valid_589395 = query.getOrDefault("oauth_token")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "oauth_token", valid_589395
  var valid_589396 = query.getOrDefault("callback")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "callback", valid_589396
  var valid_589397 = query.getOrDefault("access_token")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "access_token", valid_589397
  var valid_589398 = query.getOrDefault("uploadType")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "uploadType", valid_589398
  var valid_589399 = query.getOrDefault("key")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "key", valid_589399
  var valid_589400 = query.getOrDefault("$.xgafv")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = newJString("1"))
  if valid_589400 != nil:
    section.add "$.xgafv", valid_589400
  var valid_589401 = query.getOrDefault("pageSize")
  valid_589401 = validateParameter(valid_589401, JInt, required = false, default = nil)
  if valid_589401 != nil:
    section.add "pageSize", valid_589401
  var valid_589402 = query.getOrDefault("prettyPrint")
  valid_589402 = validateParameter(valid_589402, JBool, required = false,
                                 default = newJBool(true))
  if valid_589402 != nil:
    section.add "prettyPrint", valid_589402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589403: Call_PubsubProjectsTopicsSubscriptionsList_589386;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the names of the subscriptions on this topic.
  ## 
  let valid = call_589403.validator(path, query, header, formData, body)
  let scheme = call_589403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589403.url(scheme.get, call_589403.host, call_589403.base,
                         call_589403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589403, url, valid)

proc call*(call_589404: Call_PubsubProjectsTopicsSubscriptionsList_589386;
          topic: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## pubsubProjectsTopicsSubscriptionsList
  ## Lists the names of the subscriptions on this topic.
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
  ## Format is `projects/{project}/topics/{topic}`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of subscription names to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589405 = newJObject()
  var query_589406 = newJObject()
  add(query_589406, "upload_protocol", newJString(uploadProtocol))
  add(query_589406, "fields", newJString(fields))
  add(query_589406, "pageToken", newJString(pageToken))
  add(query_589406, "quotaUser", newJString(quotaUser))
  add(query_589406, "alt", newJString(alt))
  add(query_589406, "oauth_token", newJString(oauthToken))
  add(query_589406, "callback", newJString(callback))
  add(query_589406, "access_token", newJString(accessToken))
  add(query_589406, "uploadType", newJString(uploadType))
  add(query_589406, "key", newJString(key))
  add(path_589405, "topic", newJString(topic))
  add(query_589406, "$.xgafv", newJString(Xgafv))
  add(query_589406, "pageSize", newJInt(pageSize))
  add(query_589406, "prettyPrint", newJBool(prettyPrint))
  result = call_589404.call(path_589405, query_589406, nil, nil, nil)

var pubsubProjectsTopicsSubscriptionsList* = Call_PubsubProjectsTopicsSubscriptionsList_589386(
    name: "pubsubProjectsTopicsSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{topic}/subscriptions",
    validator: validate_PubsubProjectsTopicsSubscriptionsList_589387, base: "/",
    url: url_PubsubProjectsTopicsSubscriptionsList_589388, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsPublish_589407 = ref object of OpenApiRestCall_588441
proc url_PubsubProjectsTopicsPublish_589409(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "topic"),
               (kind: ConstantSegment, value: ":publish")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsPublish_589408(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds one or more messages to the topic. Returns `NOT_FOUND` if the topic
  ## does not exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topic: JString (required)
  ##        : The messages in the request will be published on this topic.
  ## Format is `projects/{project}/topics/{topic}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `topic` field"
  var valid_589410 = path.getOrDefault("topic")
  valid_589410 = validateParameter(valid_589410, JString, required = true,
                                 default = nil)
  if valid_589410 != nil:
    section.add "topic", valid_589410
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
  var valid_589411 = query.getOrDefault("upload_protocol")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "upload_protocol", valid_589411
  var valid_589412 = query.getOrDefault("fields")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "fields", valid_589412
  var valid_589413 = query.getOrDefault("quotaUser")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "quotaUser", valid_589413
  var valid_589414 = query.getOrDefault("alt")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = newJString("json"))
  if valid_589414 != nil:
    section.add "alt", valid_589414
  var valid_589415 = query.getOrDefault("oauth_token")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "oauth_token", valid_589415
  var valid_589416 = query.getOrDefault("callback")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "callback", valid_589416
  var valid_589417 = query.getOrDefault("access_token")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "access_token", valid_589417
  var valid_589418 = query.getOrDefault("uploadType")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "uploadType", valid_589418
  var valid_589419 = query.getOrDefault("key")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "key", valid_589419
  var valid_589420 = query.getOrDefault("$.xgafv")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = newJString("1"))
  if valid_589420 != nil:
    section.add "$.xgafv", valid_589420
  var valid_589421 = query.getOrDefault("prettyPrint")
  valid_589421 = validateParameter(valid_589421, JBool, required = false,
                                 default = newJBool(true))
  if valid_589421 != nil:
    section.add "prettyPrint", valid_589421
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

proc call*(call_589423: Call_PubsubProjectsTopicsPublish_589407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds one or more messages to the topic. Returns `NOT_FOUND` if the topic
  ## does not exist.
  ## 
  let valid = call_589423.validator(path, query, header, formData, body)
  let scheme = call_589423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589423.url(scheme.get, call_589423.host, call_589423.base,
                         call_589423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589423, url, valid)

proc call*(call_589424: Call_PubsubProjectsTopicsPublish_589407; topic: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## pubsubProjectsTopicsPublish
  ## Adds one or more messages to the topic. Returns `NOT_FOUND` if the topic
  ## does not exist.
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
  ## Format is `projects/{project}/topics/{topic}`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589425 = newJObject()
  var query_589426 = newJObject()
  var body_589427 = newJObject()
  add(query_589426, "upload_protocol", newJString(uploadProtocol))
  add(query_589426, "fields", newJString(fields))
  add(query_589426, "quotaUser", newJString(quotaUser))
  add(query_589426, "alt", newJString(alt))
  add(query_589426, "oauth_token", newJString(oauthToken))
  add(query_589426, "callback", newJString(callback))
  add(query_589426, "access_token", newJString(accessToken))
  add(query_589426, "uploadType", newJString(uploadType))
  add(query_589426, "key", newJString(key))
  add(path_589425, "topic", newJString(topic))
  add(query_589426, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589427 = body
  add(query_589426, "prettyPrint", newJBool(prettyPrint))
  result = call_589424.call(path_589425, query_589426, nil, nil, body_589427)

var pubsubProjectsTopicsPublish* = Call_PubsubProjectsTopicsPublish_589407(
    name: "pubsubProjectsTopicsPublish", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{topic}:publish",
    validator: validate_PubsubProjectsTopicsPublish_589408, base: "/",
    url: url_PubsubProjectsTopicsPublish_589409, schemes: {Scheme.Https})
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
