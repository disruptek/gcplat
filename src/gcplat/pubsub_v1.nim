
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "pubsub"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PubsubProjectsTopicsCreate_593677 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsTopicsCreate_593679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_PubsubProjectsTopicsCreate_593678(path: JsonNode; query: JsonNode;
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593853: Call_PubsubProjectsTopicsCreate_593677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the given topic with the given name. See the
  ## <a href="https://cloud.google.com/pubsub/docs/admin#resource_names">
  ## resource name rules</a>.
  ## 
  let valid = call_593853.validator(path, query, header, formData, body)
  let scheme = call_593853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593853.url(scheme.get, call_593853.host, call_593853.base,
                         call_593853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593853, url, valid)

proc call*(call_593924: Call_PubsubProjectsTopicsCreate_593677; name: string;
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
  var path_593925 = newJObject()
  var query_593927 = newJObject()
  var body_593928 = newJObject()
  add(query_593927, "upload_protocol", newJString(uploadProtocol))
  add(query_593927, "fields", newJString(fields))
  add(query_593927, "quotaUser", newJString(quotaUser))
  add(path_593925, "name", newJString(name))
  add(query_593927, "alt", newJString(alt))
  add(query_593927, "oauth_token", newJString(oauthToken))
  add(query_593927, "callback", newJString(callback))
  add(query_593927, "access_token", newJString(accessToken))
  add(query_593927, "uploadType", newJString(uploadType))
  add(query_593927, "key", newJString(key))
  add(query_593927, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593928 = body
  add(query_593927, "prettyPrint", newJBool(prettyPrint))
  result = call_593924.call(path_593925, query_593927, nil, nil, body_593928)

var pubsubProjectsTopicsCreate* = Call_PubsubProjectsTopicsCreate_593677(
    name: "pubsubProjectsTopicsCreate", meth: HttpMethod.HttpPut,
    host: "pubsub.googleapis.com", route: "/v1/{name}",
    validator: validate_PubsubProjectsTopicsCreate_593678, base: "/",
    url: url_PubsubProjectsTopicsCreate_593679, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsPatch_593967 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsTopicsPatch_593969(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_PubsubProjectsTopicsPatch_593968(path: JsonNode; query: JsonNode;
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
  var valid_593970 = path.getOrDefault("name")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "name", valid_593970
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
  var valid_593971 = query.getOrDefault("upload_protocol")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "upload_protocol", valid_593971
  var valid_593972 = query.getOrDefault("fields")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "fields", valid_593972
  var valid_593973 = query.getOrDefault("quotaUser")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "quotaUser", valid_593973
  var valid_593974 = query.getOrDefault("alt")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = newJString("json"))
  if valid_593974 != nil:
    section.add "alt", valid_593974
  var valid_593975 = query.getOrDefault("oauth_token")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "oauth_token", valid_593975
  var valid_593976 = query.getOrDefault("callback")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "callback", valid_593976
  var valid_593977 = query.getOrDefault("access_token")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "access_token", valid_593977
  var valid_593978 = query.getOrDefault("uploadType")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "uploadType", valid_593978
  var valid_593979 = query.getOrDefault("key")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "key", valid_593979
  var valid_593980 = query.getOrDefault("$.xgafv")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = newJString("1"))
  if valid_593980 != nil:
    section.add "$.xgafv", valid_593980
  var valid_593981 = query.getOrDefault("prettyPrint")
  valid_593981 = validateParameter(valid_593981, JBool, required = false,
                                 default = newJBool(true))
  if valid_593981 != nil:
    section.add "prettyPrint", valid_593981
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

proc call*(call_593983: Call_PubsubProjectsTopicsPatch_593967; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing topic. Note that certain properties of a
  ## topic are not modifiable.
  ## 
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_PubsubProjectsTopicsPatch_593967; name: string;
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
  var path_593985 = newJObject()
  var query_593986 = newJObject()
  var body_593987 = newJObject()
  add(query_593986, "upload_protocol", newJString(uploadProtocol))
  add(query_593986, "fields", newJString(fields))
  add(query_593986, "quotaUser", newJString(quotaUser))
  add(path_593985, "name", newJString(name))
  add(query_593986, "alt", newJString(alt))
  add(query_593986, "oauth_token", newJString(oauthToken))
  add(query_593986, "callback", newJString(callback))
  add(query_593986, "access_token", newJString(accessToken))
  add(query_593986, "uploadType", newJString(uploadType))
  add(query_593986, "key", newJString(key))
  add(query_593986, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593987 = body
  add(query_593986, "prettyPrint", newJBool(prettyPrint))
  result = call_593984.call(path_593985, query_593986, nil, nil, body_593987)

var pubsubProjectsTopicsPatch* = Call_PubsubProjectsTopicsPatch_593967(
    name: "pubsubProjectsTopicsPatch", meth: HttpMethod.HttpPatch,
    host: "pubsub.googleapis.com", route: "/v1/{name}",
    validator: validate_PubsubProjectsTopicsPatch_593968, base: "/",
    url: url_PubsubProjectsTopicsPatch_593969, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSnapshotsList_593988 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsSnapshotsList_593990(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PubsubProjectsSnapshotsList_593989(path: JsonNode; query: JsonNode;
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
  var valid_593991 = path.getOrDefault("project")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "project", valid_593991
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
  var valid_593992 = query.getOrDefault("upload_protocol")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "upload_protocol", valid_593992
  var valid_593993 = query.getOrDefault("fields")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "fields", valid_593993
  var valid_593994 = query.getOrDefault("pageToken")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "pageToken", valid_593994
  var valid_593995 = query.getOrDefault("quotaUser")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "quotaUser", valid_593995
  var valid_593996 = query.getOrDefault("alt")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = newJString("json"))
  if valid_593996 != nil:
    section.add "alt", valid_593996
  var valid_593997 = query.getOrDefault("oauth_token")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "oauth_token", valid_593997
  var valid_593998 = query.getOrDefault("callback")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "callback", valid_593998
  var valid_593999 = query.getOrDefault("access_token")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "access_token", valid_593999
  var valid_594000 = query.getOrDefault("uploadType")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "uploadType", valid_594000
  var valid_594001 = query.getOrDefault("key")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "key", valid_594001
  var valid_594002 = query.getOrDefault("$.xgafv")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = newJString("1"))
  if valid_594002 != nil:
    section.add "$.xgafv", valid_594002
  var valid_594003 = query.getOrDefault("pageSize")
  valid_594003 = validateParameter(valid_594003, JInt, required = false, default = nil)
  if valid_594003 != nil:
    section.add "pageSize", valid_594003
  var valid_594004 = query.getOrDefault("prettyPrint")
  valid_594004 = validateParameter(valid_594004, JBool, required = false,
                                 default = newJBool(true))
  if valid_594004 != nil:
    section.add "prettyPrint", valid_594004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594005: Call_PubsubProjectsSnapshotsList_593988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the existing snapshots. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.
  ## 
  let valid = call_594005.validator(path, query, header, formData, body)
  let scheme = call_594005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594005.url(scheme.get, call_594005.host, call_594005.base,
                         call_594005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594005, url, valid)

proc call*(call_594006: Call_PubsubProjectsSnapshotsList_593988; project: string;
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
  var path_594007 = newJObject()
  var query_594008 = newJObject()
  add(query_594008, "upload_protocol", newJString(uploadProtocol))
  add(query_594008, "fields", newJString(fields))
  add(query_594008, "pageToken", newJString(pageToken))
  add(query_594008, "quotaUser", newJString(quotaUser))
  add(query_594008, "alt", newJString(alt))
  add(query_594008, "oauth_token", newJString(oauthToken))
  add(query_594008, "callback", newJString(callback))
  add(query_594008, "access_token", newJString(accessToken))
  add(query_594008, "uploadType", newJString(uploadType))
  add(query_594008, "key", newJString(key))
  add(query_594008, "$.xgafv", newJString(Xgafv))
  add(query_594008, "pageSize", newJInt(pageSize))
  add(path_594007, "project", newJString(project))
  add(query_594008, "prettyPrint", newJBool(prettyPrint))
  result = call_594006.call(path_594007, query_594008, nil, nil, nil)

var pubsubProjectsSnapshotsList* = Call_PubsubProjectsSnapshotsList_593988(
    name: "pubsubProjectsSnapshotsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{project}/snapshots",
    validator: validate_PubsubProjectsSnapshotsList_593989, base: "/",
    url: url_PubsubProjectsSnapshotsList_593990, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsList_594009 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsSubscriptionsList_594011(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PubsubProjectsSubscriptionsList_594010(path: JsonNode;
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
  var valid_594012 = path.getOrDefault("project")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "project", valid_594012
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
  var valid_594013 = query.getOrDefault("upload_protocol")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "upload_protocol", valid_594013
  var valid_594014 = query.getOrDefault("fields")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "fields", valid_594014
  var valid_594015 = query.getOrDefault("pageToken")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "pageToken", valid_594015
  var valid_594016 = query.getOrDefault("quotaUser")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "quotaUser", valid_594016
  var valid_594017 = query.getOrDefault("alt")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = newJString("json"))
  if valid_594017 != nil:
    section.add "alt", valid_594017
  var valid_594018 = query.getOrDefault("oauth_token")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "oauth_token", valid_594018
  var valid_594019 = query.getOrDefault("callback")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "callback", valid_594019
  var valid_594020 = query.getOrDefault("access_token")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "access_token", valid_594020
  var valid_594021 = query.getOrDefault("uploadType")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "uploadType", valid_594021
  var valid_594022 = query.getOrDefault("key")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "key", valid_594022
  var valid_594023 = query.getOrDefault("$.xgafv")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = newJString("1"))
  if valid_594023 != nil:
    section.add "$.xgafv", valid_594023
  var valid_594024 = query.getOrDefault("pageSize")
  valid_594024 = validateParameter(valid_594024, JInt, required = false, default = nil)
  if valid_594024 != nil:
    section.add "pageSize", valid_594024
  var valid_594025 = query.getOrDefault("prettyPrint")
  valid_594025 = validateParameter(valid_594025, JBool, required = false,
                                 default = newJBool(true))
  if valid_594025 != nil:
    section.add "prettyPrint", valid_594025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_PubsubProjectsSubscriptionsList_594009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists matching subscriptions.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_PubsubProjectsSubscriptionsList_594009;
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
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(query_594029, "upload_protocol", newJString(uploadProtocol))
  add(query_594029, "fields", newJString(fields))
  add(query_594029, "pageToken", newJString(pageToken))
  add(query_594029, "quotaUser", newJString(quotaUser))
  add(query_594029, "alt", newJString(alt))
  add(query_594029, "oauth_token", newJString(oauthToken))
  add(query_594029, "callback", newJString(callback))
  add(query_594029, "access_token", newJString(accessToken))
  add(query_594029, "uploadType", newJString(uploadType))
  add(query_594029, "key", newJString(key))
  add(query_594029, "$.xgafv", newJString(Xgafv))
  add(query_594029, "pageSize", newJInt(pageSize))
  add(path_594028, "project", newJString(project))
  add(query_594029, "prettyPrint", newJBool(prettyPrint))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var pubsubProjectsSubscriptionsList* = Call_PubsubProjectsSubscriptionsList_594009(
    name: "pubsubProjectsSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{project}/subscriptions",
    validator: validate_PubsubProjectsSubscriptionsList_594010, base: "/",
    url: url_PubsubProjectsSubscriptionsList_594011, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsList_594030 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsTopicsList_594032(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PubsubProjectsTopicsList_594031(path: JsonNode; query: JsonNode;
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
  var valid_594033 = path.getOrDefault("project")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "project", valid_594033
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
  var valid_594034 = query.getOrDefault("upload_protocol")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "upload_protocol", valid_594034
  var valid_594035 = query.getOrDefault("fields")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "fields", valid_594035
  var valid_594036 = query.getOrDefault("pageToken")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "pageToken", valid_594036
  var valid_594037 = query.getOrDefault("quotaUser")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "quotaUser", valid_594037
  var valid_594038 = query.getOrDefault("alt")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = newJString("json"))
  if valid_594038 != nil:
    section.add "alt", valid_594038
  var valid_594039 = query.getOrDefault("oauth_token")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "oauth_token", valid_594039
  var valid_594040 = query.getOrDefault("callback")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "callback", valid_594040
  var valid_594041 = query.getOrDefault("access_token")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "access_token", valid_594041
  var valid_594042 = query.getOrDefault("uploadType")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "uploadType", valid_594042
  var valid_594043 = query.getOrDefault("key")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "key", valid_594043
  var valid_594044 = query.getOrDefault("$.xgafv")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = newJString("1"))
  if valid_594044 != nil:
    section.add "$.xgafv", valid_594044
  var valid_594045 = query.getOrDefault("pageSize")
  valid_594045 = validateParameter(valid_594045, JInt, required = false, default = nil)
  if valid_594045 != nil:
    section.add "pageSize", valid_594045
  var valid_594046 = query.getOrDefault("prettyPrint")
  valid_594046 = validateParameter(valid_594046, JBool, required = false,
                                 default = newJBool(true))
  if valid_594046 != nil:
    section.add "prettyPrint", valid_594046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594047: Call_PubsubProjectsTopicsList_594030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists matching topics.
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_PubsubProjectsTopicsList_594030; project: string;
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
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  add(query_594050, "upload_protocol", newJString(uploadProtocol))
  add(query_594050, "fields", newJString(fields))
  add(query_594050, "pageToken", newJString(pageToken))
  add(query_594050, "quotaUser", newJString(quotaUser))
  add(query_594050, "alt", newJString(alt))
  add(query_594050, "oauth_token", newJString(oauthToken))
  add(query_594050, "callback", newJString(callback))
  add(query_594050, "access_token", newJString(accessToken))
  add(query_594050, "uploadType", newJString(uploadType))
  add(query_594050, "key", newJString(key))
  add(query_594050, "$.xgafv", newJString(Xgafv))
  add(query_594050, "pageSize", newJInt(pageSize))
  add(path_594049, "project", newJString(project))
  add(query_594050, "prettyPrint", newJBool(prettyPrint))
  result = call_594048.call(path_594049, query_594050, nil, nil, nil)

var pubsubProjectsTopicsList* = Call_PubsubProjectsTopicsList_594030(
    name: "pubsubProjectsTopicsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{project}/topics",
    validator: validate_PubsubProjectsTopicsList_594031, base: "/",
    url: url_PubsubProjectsTopicsList_594032, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsGetIamPolicy_594051 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsTopicsGetIamPolicy_594053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_PubsubProjectsTopicsGetIamPolicy_594052(path: JsonNode;
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
  var valid_594054 = path.getOrDefault("resource")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "resource", valid_594054
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
  var valid_594055 = query.getOrDefault("upload_protocol")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "upload_protocol", valid_594055
  var valid_594056 = query.getOrDefault("fields")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "fields", valid_594056
  var valid_594057 = query.getOrDefault("quotaUser")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "quotaUser", valid_594057
  var valid_594058 = query.getOrDefault("alt")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = newJString("json"))
  if valid_594058 != nil:
    section.add "alt", valid_594058
  var valid_594059 = query.getOrDefault("oauth_token")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "oauth_token", valid_594059
  var valid_594060 = query.getOrDefault("callback")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "callback", valid_594060
  var valid_594061 = query.getOrDefault("access_token")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "access_token", valid_594061
  var valid_594062 = query.getOrDefault("uploadType")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "uploadType", valid_594062
  var valid_594063 = query.getOrDefault("options.requestedPolicyVersion")
  valid_594063 = validateParameter(valid_594063, JInt, required = false, default = nil)
  if valid_594063 != nil:
    section.add "options.requestedPolicyVersion", valid_594063
  var valid_594064 = query.getOrDefault("key")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "key", valid_594064
  var valid_594065 = query.getOrDefault("$.xgafv")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = newJString("1"))
  if valid_594065 != nil:
    section.add "$.xgafv", valid_594065
  var valid_594066 = query.getOrDefault("prettyPrint")
  valid_594066 = validateParameter(valid_594066, JBool, required = false,
                                 default = newJBool(true))
  if valid_594066 != nil:
    section.add "prettyPrint", valid_594066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594067: Call_PubsubProjectsTopicsGetIamPolicy_594051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_PubsubProjectsTopicsGetIamPolicy_594051;
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
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  add(query_594070, "upload_protocol", newJString(uploadProtocol))
  add(query_594070, "fields", newJString(fields))
  add(query_594070, "quotaUser", newJString(quotaUser))
  add(query_594070, "alt", newJString(alt))
  add(query_594070, "oauth_token", newJString(oauthToken))
  add(query_594070, "callback", newJString(callback))
  add(query_594070, "access_token", newJString(accessToken))
  add(query_594070, "uploadType", newJString(uploadType))
  add(query_594070, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_594070, "key", newJString(key))
  add(query_594070, "$.xgafv", newJString(Xgafv))
  add(path_594069, "resource", newJString(resource))
  add(query_594070, "prettyPrint", newJBool(prettyPrint))
  result = call_594068.call(path_594069, query_594070, nil, nil, nil)

var pubsubProjectsTopicsGetIamPolicy* = Call_PubsubProjectsTopicsGetIamPolicy_594051(
    name: "pubsubProjectsTopicsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_PubsubProjectsTopicsGetIamPolicy_594052, base: "/",
    url: url_PubsubProjectsTopicsGetIamPolicy_594053, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsSetIamPolicy_594071 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsTopicsSetIamPolicy_594073(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_PubsubProjectsTopicsSetIamPolicy_594072(path: JsonNode;
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
  var valid_594074 = path.getOrDefault("resource")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "resource", valid_594074
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
  var valid_594075 = query.getOrDefault("upload_protocol")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "upload_protocol", valid_594075
  var valid_594076 = query.getOrDefault("fields")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "fields", valid_594076
  var valid_594077 = query.getOrDefault("quotaUser")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "quotaUser", valid_594077
  var valid_594078 = query.getOrDefault("alt")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = newJString("json"))
  if valid_594078 != nil:
    section.add "alt", valid_594078
  var valid_594079 = query.getOrDefault("oauth_token")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "oauth_token", valid_594079
  var valid_594080 = query.getOrDefault("callback")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "callback", valid_594080
  var valid_594081 = query.getOrDefault("access_token")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "access_token", valid_594081
  var valid_594082 = query.getOrDefault("uploadType")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "uploadType", valid_594082
  var valid_594083 = query.getOrDefault("key")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "key", valid_594083
  var valid_594084 = query.getOrDefault("$.xgafv")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = newJString("1"))
  if valid_594084 != nil:
    section.add "$.xgafv", valid_594084
  var valid_594085 = query.getOrDefault("prettyPrint")
  valid_594085 = validateParameter(valid_594085, JBool, required = false,
                                 default = newJBool(true))
  if valid_594085 != nil:
    section.add "prettyPrint", valid_594085
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

proc call*(call_594087: Call_PubsubProjectsTopicsSetIamPolicy_594071;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_PubsubProjectsTopicsSetIamPolicy_594071;
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
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  var body_594091 = newJObject()
  add(query_594090, "upload_protocol", newJString(uploadProtocol))
  add(query_594090, "fields", newJString(fields))
  add(query_594090, "quotaUser", newJString(quotaUser))
  add(query_594090, "alt", newJString(alt))
  add(query_594090, "oauth_token", newJString(oauthToken))
  add(query_594090, "callback", newJString(callback))
  add(query_594090, "access_token", newJString(accessToken))
  add(query_594090, "uploadType", newJString(uploadType))
  add(query_594090, "key", newJString(key))
  add(query_594090, "$.xgafv", newJString(Xgafv))
  add(path_594089, "resource", newJString(resource))
  if body != nil:
    body_594091 = body
  add(query_594090, "prettyPrint", newJBool(prettyPrint))
  result = call_594088.call(path_594089, query_594090, nil, nil, body_594091)

var pubsubProjectsTopicsSetIamPolicy* = Call_PubsubProjectsTopicsSetIamPolicy_594071(
    name: "pubsubProjectsTopicsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_PubsubProjectsTopicsSetIamPolicy_594072, base: "/",
    url: url_PubsubProjectsTopicsSetIamPolicy_594073, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsTestIamPermissions_594092 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsTopicsTestIamPermissions_594094(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_PubsubProjectsTopicsTestIamPermissions_594093(path: JsonNode;
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
  var valid_594095 = path.getOrDefault("resource")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "resource", valid_594095
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
  var valid_594096 = query.getOrDefault("upload_protocol")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "upload_protocol", valid_594096
  var valid_594097 = query.getOrDefault("fields")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "fields", valid_594097
  var valid_594098 = query.getOrDefault("quotaUser")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "quotaUser", valid_594098
  var valid_594099 = query.getOrDefault("alt")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = newJString("json"))
  if valid_594099 != nil:
    section.add "alt", valid_594099
  var valid_594100 = query.getOrDefault("oauth_token")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "oauth_token", valid_594100
  var valid_594101 = query.getOrDefault("callback")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "callback", valid_594101
  var valid_594102 = query.getOrDefault("access_token")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "access_token", valid_594102
  var valid_594103 = query.getOrDefault("uploadType")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "uploadType", valid_594103
  var valid_594104 = query.getOrDefault("key")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "key", valid_594104
  var valid_594105 = query.getOrDefault("$.xgafv")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = newJString("1"))
  if valid_594105 != nil:
    section.add "$.xgafv", valid_594105
  var valid_594106 = query.getOrDefault("prettyPrint")
  valid_594106 = validateParameter(valid_594106, JBool, required = false,
                                 default = newJBool(true))
  if valid_594106 != nil:
    section.add "prettyPrint", valid_594106
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

proc call*(call_594108: Call_PubsubProjectsTopicsTestIamPermissions_594092;
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
  let valid = call_594108.validator(path, query, header, formData, body)
  let scheme = call_594108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594108.url(scheme.get, call_594108.host, call_594108.base,
                         call_594108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594108, url, valid)

proc call*(call_594109: Call_PubsubProjectsTopicsTestIamPermissions_594092;
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
  var path_594110 = newJObject()
  var query_594111 = newJObject()
  var body_594112 = newJObject()
  add(query_594111, "upload_protocol", newJString(uploadProtocol))
  add(query_594111, "fields", newJString(fields))
  add(query_594111, "quotaUser", newJString(quotaUser))
  add(query_594111, "alt", newJString(alt))
  add(query_594111, "oauth_token", newJString(oauthToken))
  add(query_594111, "callback", newJString(callback))
  add(query_594111, "access_token", newJString(accessToken))
  add(query_594111, "uploadType", newJString(uploadType))
  add(query_594111, "key", newJString(key))
  add(query_594111, "$.xgafv", newJString(Xgafv))
  add(path_594110, "resource", newJString(resource))
  if body != nil:
    body_594112 = body
  add(query_594111, "prettyPrint", newJBool(prettyPrint))
  result = call_594109.call(path_594110, query_594111, nil, nil, body_594112)

var pubsubProjectsTopicsTestIamPermissions* = Call_PubsubProjectsTopicsTestIamPermissions_594092(
    name: "pubsubProjectsTopicsTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{resource}:testIamPermissions",
    validator: validate_PubsubProjectsTopicsTestIamPermissions_594093, base: "/",
    url: url_PubsubProjectsTopicsTestIamPermissions_594094,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSnapshotsGet_594113 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsSnapshotsGet_594115(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "snapshot" in path, "`snapshot` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "snapshot")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSnapshotsGet_594114(path: JsonNode; query: JsonNode;
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
  var valid_594116 = path.getOrDefault("snapshot")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "snapshot", valid_594116
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
  var valid_594117 = query.getOrDefault("upload_protocol")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "upload_protocol", valid_594117
  var valid_594118 = query.getOrDefault("fields")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "fields", valid_594118
  var valid_594119 = query.getOrDefault("quotaUser")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "quotaUser", valid_594119
  var valid_594120 = query.getOrDefault("alt")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = newJString("json"))
  if valid_594120 != nil:
    section.add "alt", valid_594120
  var valid_594121 = query.getOrDefault("oauth_token")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "oauth_token", valid_594121
  var valid_594122 = query.getOrDefault("callback")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "callback", valid_594122
  var valid_594123 = query.getOrDefault("access_token")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "access_token", valid_594123
  var valid_594124 = query.getOrDefault("uploadType")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "uploadType", valid_594124
  var valid_594125 = query.getOrDefault("key")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "key", valid_594125
  var valid_594126 = query.getOrDefault("$.xgafv")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = newJString("1"))
  if valid_594126 != nil:
    section.add "$.xgafv", valid_594126
  var valid_594127 = query.getOrDefault("prettyPrint")
  valid_594127 = validateParameter(valid_594127, JBool, required = false,
                                 default = newJBool(true))
  if valid_594127 != nil:
    section.add "prettyPrint", valid_594127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594128: Call_PubsubProjectsSnapshotsGet_594113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration details of a snapshot. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow you to manage message acknowledgments in bulk. That
  ## is, you can set the acknowledgment state of messages in an existing
  ## subscription to the state captured by a snapshot.
  ## 
  let valid = call_594128.validator(path, query, header, formData, body)
  let scheme = call_594128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594128.url(scheme.get, call_594128.host, call_594128.base,
                         call_594128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594128, url, valid)

proc call*(call_594129: Call_PubsubProjectsSnapshotsGet_594113; snapshot: string;
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
  var path_594130 = newJObject()
  var query_594131 = newJObject()
  add(query_594131, "upload_protocol", newJString(uploadProtocol))
  add(query_594131, "fields", newJString(fields))
  add(query_594131, "quotaUser", newJString(quotaUser))
  add(query_594131, "alt", newJString(alt))
  add(query_594131, "oauth_token", newJString(oauthToken))
  add(query_594131, "callback", newJString(callback))
  add(query_594131, "access_token", newJString(accessToken))
  add(query_594131, "uploadType", newJString(uploadType))
  add(query_594131, "key", newJString(key))
  add(query_594131, "$.xgafv", newJString(Xgafv))
  add(path_594130, "snapshot", newJString(snapshot))
  add(query_594131, "prettyPrint", newJBool(prettyPrint))
  result = call_594129.call(path_594130, query_594131, nil, nil, nil)

var pubsubProjectsSnapshotsGet* = Call_PubsubProjectsSnapshotsGet_594113(
    name: "pubsubProjectsSnapshotsGet", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{snapshot}",
    validator: validate_PubsubProjectsSnapshotsGet_594114, base: "/",
    url: url_PubsubProjectsSnapshotsGet_594115, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSnapshotsDelete_594132 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsSnapshotsDelete_594134(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "snapshot" in path, "`snapshot` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "snapshot")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSnapshotsDelete_594133(path: JsonNode; query: JsonNode;
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
  var valid_594135 = path.getOrDefault("snapshot")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "snapshot", valid_594135
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
  var valid_594136 = query.getOrDefault("upload_protocol")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "upload_protocol", valid_594136
  var valid_594137 = query.getOrDefault("fields")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "fields", valid_594137
  var valid_594138 = query.getOrDefault("quotaUser")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "quotaUser", valid_594138
  var valid_594139 = query.getOrDefault("alt")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = newJString("json"))
  if valid_594139 != nil:
    section.add "alt", valid_594139
  var valid_594140 = query.getOrDefault("oauth_token")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "oauth_token", valid_594140
  var valid_594141 = query.getOrDefault("callback")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "callback", valid_594141
  var valid_594142 = query.getOrDefault("access_token")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "access_token", valid_594142
  var valid_594143 = query.getOrDefault("uploadType")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "uploadType", valid_594143
  var valid_594144 = query.getOrDefault("key")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "key", valid_594144
  var valid_594145 = query.getOrDefault("$.xgafv")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = newJString("1"))
  if valid_594145 != nil:
    section.add "$.xgafv", valid_594145
  var valid_594146 = query.getOrDefault("prettyPrint")
  valid_594146 = validateParameter(valid_594146, JBool, required = false,
                                 default = newJBool(true))
  if valid_594146 != nil:
    section.add "prettyPrint", valid_594146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594147: Call_PubsubProjectsSnapshotsDelete_594132; path: JsonNode;
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
  let valid = call_594147.validator(path, query, header, formData, body)
  let scheme = call_594147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594147.url(scheme.get, call_594147.host, call_594147.base,
                         call_594147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594147, url, valid)

proc call*(call_594148: Call_PubsubProjectsSnapshotsDelete_594132;
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
  var path_594149 = newJObject()
  var query_594150 = newJObject()
  add(query_594150, "upload_protocol", newJString(uploadProtocol))
  add(query_594150, "fields", newJString(fields))
  add(query_594150, "quotaUser", newJString(quotaUser))
  add(query_594150, "alt", newJString(alt))
  add(query_594150, "oauth_token", newJString(oauthToken))
  add(query_594150, "callback", newJString(callback))
  add(query_594150, "access_token", newJString(accessToken))
  add(query_594150, "uploadType", newJString(uploadType))
  add(query_594150, "key", newJString(key))
  add(query_594150, "$.xgafv", newJString(Xgafv))
  add(path_594149, "snapshot", newJString(snapshot))
  add(query_594150, "prettyPrint", newJBool(prettyPrint))
  result = call_594148.call(path_594149, query_594150, nil, nil, nil)

var pubsubProjectsSnapshotsDelete* = Call_PubsubProjectsSnapshotsDelete_594132(
    name: "pubsubProjectsSnapshotsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com", route: "/v1/{snapshot}",
    validator: validate_PubsubProjectsSnapshotsDelete_594133, base: "/",
    url: url_PubsubProjectsSnapshotsDelete_594134, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsGet_594151 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsSubscriptionsGet_594153(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "subscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsGet_594152(path: JsonNode;
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
  var valid_594154 = path.getOrDefault("subscription")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "subscription", valid_594154
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
  var valid_594155 = query.getOrDefault("upload_protocol")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "upload_protocol", valid_594155
  var valid_594156 = query.getOrDefault("fields")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "fields", valid_594156
  var valid_594157 = query.getOrDefault("quotaUser")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "quotaUser", valid_594157
  var valid_594158 = query.getOrDefault("alt")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = newJString("json"))
  if valid_594158 != nil:
    section.add "alt", valid_594158
  var valid_594159 = query.getOrDefault("oauth_token")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "oauth_token", valid_594159
  var valid_594160 = query.getOrDefault("callback")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "callback", valid_594160
  var valid_594161 = query.getOrDefault("access_token")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "access_token", valid_594161
  var valid_594162 = query.getOrDefault("uploadType")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "uploadType", valid_594162
  var valid_594163 = query.getOrDefault("key")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "key", valid_594163
  var valid_594164 = query.getOrDefault("$.xgafv")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = newJString("1"))
  if valid_594164 != nil:
    section.add "$.xgafv", valid_594164
  var valid_594165 = query.getOrDefault("prettyPrint")
  valid_594165 = validateParameter(valid_594165, JBool, required = false,
                                 default = newJBool(true))
  if valid_594165 != nil:
    section.add "prettyPrint", valid_594165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594166: Call_PubsubProjectsSubscriptionsGet_594151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration details of a subscription.
  ## 
  let valid = call_594166.validator(path, query, header, formData, body)
  let scheme = call_594166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594166.url(scheme.get, call_594166.host, call_594166.base,
                         call_594166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594166, url, valid)

proc call*(call_594167: Call_PubsubProjectsSubscriptionsGet_594151;
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
  var path_594168 = newJObject()
  var query_594169 = newJObject()
  add(query_594169, "upload_protocol", newJString(uploadProtocol))
  add(query_594169, "fields", newJString(fields))
  add(query_594169, "quotaUser", newJString(quotaUser))
  add(path_594168, "subscription", newJString(subscription))
  add(query_594169, "alt", newJString(alt))
  add(query_594169, "oauth_token", newJString(oauthToken))
  add(query_594169, "callback", newJString(callback))
  add(query_594169, "access_token", newJString(accessToken))
  add(query_594169, "uploadType", newJString(uploadType))
  add(query_594169, "key", newJString(key))
  add(query_594169, "$.xgafv", newJString(Xgafv))
  add(query_594169, "prettyPrint", newJBool(prettyPrint))
  result = call_594167.call(path_594168, query_594169, nil, nil, nil)

var pubsubProjectsSubscriptionsGet* = Call_PubsubProjectsSubscriptionsGet_594151(
    name: "pubsubProjectsSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{subscription}",
    validator: validate_PubsubProjectsSubscriptionsGet_594152, base: "/",
    url: url_PubsubProjectsSubscriptionsGet_594153, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsDelete_594170 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsSubscriptionsDelete_594172(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "subscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsSubscriptionsDelete_594171(path: JsonNode;
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
  var valid_594173 = path.getOrDefault("subscription")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "subscription", valid_594173
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
  var valid_594174 = query.getOrDefault("upload_protocol")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "upload_protocol", valid_594174
  var valid_594175 = query.getOrDefault("fields")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "fields", valid_594175
  var valid_594176 = query.getOrDefault("quotaUser")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "quotaUser", valid_594176
  var valid_594177 = query.getOrDefault("alt")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = newJString("json"))
  if valid_594177 != nil:
    section.add "alt", valid_594177
  var valid_594178 = query.getOrDefault("oauth_token")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "oauth_token", valid_594178
  var valid_594179 = query.getOrDefault("callback")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "callback", valid_594179
  var valid_594180 = query.getOrDefault("access_token")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "access_token", valid_594180
  var valid_594181 = query.getOrDefault("uploadType")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = nil)
  if valid_594181 != nil:
    section.add "uploadType", valid_594181
  var valid_594182 = query.getOrDefault("key")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "key", valid_594182
  var valid_594183 = query.getOrDefault("$.xgafv")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = newJString("1"))
  if valid_594183 != nil:
    section.add "$.xgafv", valid_594183
  var valid_594184 = query.getOrDefault("prettyPrint")
  valid_594184 = validateParameter(valid_594184, JBool, required = false,
                                 default = newJBool(true))
  if valid_594184 != nil:
    section.add "prettyPrint", valid_594184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594185: Call_PubsubProjectsSubscriptionsDelete_594170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an existing subscription. All messages retained in the subscription
  ## are immediately dropped. Calls to `Pull` after deletion will return
  ## `NOT_FOUND`. After a subscription is deleted, a new one may be created with
  ## the same name, but the new one has no association with the old
  ## subscription or its topic unless the same topic is specified.
  ## 
  let valid = call_594185.validator(path, query, header, formData, body)
  let scheme = call_594185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594185.url(scheme.get, call_594185.host, call_594185.base,
                         call_594185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594185, url, valid)

proc call*(call_594186: Call_PubsubProjectsSubscriptionsDelete_594170;
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
  var path_594187 = newJObject()
  var query_594188 = newJObject()
  add(query_594188, "upload_protocol", newJString(uploadProtocol))
  add(query_594188, "fields", newJString(fields))
  add(query_594188, "quotaUser", newJString(quotaUser))
  add(path_594187, "subscription", newJString(subscription))
  add(query_594188, "alt", newJString(alt))
  add(query_594188, "oauth_token", newJString(oauthToken))
  add(query_594188, "callback", newJString(callback))
  add(query_594188, "access_token", newJString(accessToken))
  add(query_594188, "uploadType", newJString(uploadType))
  add(query_594188, "key", newJString(key))
  add(query_594188, "$.xgafv", newJString(Xgafv))
  add(query_594188, "prettyPrint", newJBool(prettyPrint))
  result = call_594186.call(path_594187, query_594188, nil, nil, nil)

var pubsubProjectsSubscriptionsDelete* = Call_PubsubProjectsSubscriptionsDelete_594170(
    name: "pubsubProjectsSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com", route: "/v1/{subscription}",
    validator: validate_PubsubProjectsSubscriptionsDelete_594171, base: "/",
    url: url_PubsubProjectsSubscriptionsDelete_594172, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsAcknowledge_594189 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsSubscriptionsAcknowledge_594191(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PubsubProjectsSubscriptionsAcknowledge_594190(path: JsonNode;
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
  var valid_594192 = path.getOrDefault("subscription")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "subscription", valid_594192
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
  var valid_594193 = query.getOrDefault("upload_protocol")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "upload_protocol", valid_594193
  var valid_594194 = query.getOrDefault("fields")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "fields", valid_594194
  var valid_594195 = query.getOrDefault("quotaUser")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "quotaUser", valid_594195
  var valid_594196 = query.getOrDefault("alt")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = newJString("json"))
  if valid_594196 != nil:
    section.add "alt", valid_594196
  var valid_594197 = query.getOrDefault("oauth_token")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "oauth_token", valid_594197
  var valid_594198 = query.getOrDefault("callback")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "callback", valid_594198
  var valid_594199 = query.getOrDefault("access_token")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "access_token", valid_594199
  var valid_594200 = query.getOrDefault("uploadType")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "uploadType", valid_594200
  var valid_594201 = query.getOrDefault("key")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "key", valid_594201
  var valid_594202 = query.getOrDefault("$.xgafv")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = newJString("1"))
  if valid_594202 != nil:
    section.add "$.xgafv", valid_594202
  var valid_594203 = query.getOrDefault("prettyPrint")
  valid_594203 = validateParameter(valid_594203, JBool, required = false,
                                 default = newJBool(true))
  if valid_594203 != nil:
    section.add "prettyPrint", valid_594203
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

proc call*(call_594205: Call_PubsubProjectsSubscriptionsAcknowledge_594189;
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
  let valid = call_594205.validator(path, query, header, formData, body)
  let scheme = call_594205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594205.url(scheme.get, call_594205.host, call_594205.base,
                         call_594205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594205, url, valid)

proc call*(call_594206: Call_PubsubProjectsSubscriptionsAcknowledge_594189;
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
  var path_594207 = newJObject()
  var query_594208 = newJObject()
  var body_594209 = newJObject()
  add(query_594208, "upload_protocol", newJString(uploadProtocol))
  add(query_594208, "fields", newJString(fields))
  add(query_594208, "quotaUser", newJString(quotaUser))
  add(path_594207, "subscription", newJString(subscription))
  add(query_594208, "alt", newJString(alt))
  add(query_594208, "oauth_token", newJString(oauthToken))
  add(query_594208, "callback", newJString(callback))
  add(query_594208, "access_token", newJString(accessToken))
  add(query_594208, "uploadType", newJString(uploadType))
  add(query_594208, "key", newJString(key))
  add(query_594208, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594209 = body
  add(query_594208, "prettyPrint", newJBool(prettyPrint))
  result = call_594206.call(path_594207, query_594208, nil, nil, body_594209)

var pubsubProjectsSubscriptionsAcknowledge* = Call_PubsubProjectsSubscriptionsAcknowledge_594189(
    name: "pubsubProjectsSubscriptionsAcknowledge", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{subscription}:acknowledge",
    validator: validate_PubsubProjectsSubscriptionsAcknowledge_594190, base: "/",
    url: url_PubsubProjectsSubscriptionsAcknowledge_594191,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsModifyAckDeadline_594210 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsSubscriptionsModifyAckDeadline_594212(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PubsubProjectsSubscriptionsModifyAckDeadline_594211(path: JsonNode;
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
  var valid_594213 = path.getOrDefault("subscription")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "subscription", valid_594213
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
  var valid_594214 = query.getOrDefault("upload_protocol")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "upload_protocol", valid_594214
  var valid_594215 = query.getOrDefault("fields")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "fields", valid_594215
  var valid_594216 = query.getOrDefault("quotaUser")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "quotaUser", valid_594216
  var valid_594217 = query.getOrDefault("alt")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = newJString("json"))
  if valid_594217 != nil:
    section.add "alt", valid_594217
  var valid_594218 = query.getOrDefault("oauth_token")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "oauth_token", valid_594218
  var valid_594219 = query.getOrDefault("callback")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "callback", valid_594219
  var valid_594220 = query.getOrDefault("access_token")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "access_token", valid_594220
  var valid_594221 = query.getOrDefault("uploadType")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "uploadType", valid_594221
  var valid_594222 = query.getOrDefault("key")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "key", valid_594222
  var valid_594223 = query.getOrDefault("$.xgafv")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = newJString("1"))
  if valid_594223 != nil:
    section.add "$.xgafv", valid_594223
  var valid_594224 = query.getOrDefault("prettyPrint")
  valid_594224 = validateParameter(valid_594224, JBool, required = false,
                                 default = newJBool(true))
  if valid_594224 != nil:
    section.add "prettyPrint", valid_594224
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

proc call*(call_594226: Call_PubsubProjectsSubscriptionsModifyAckDeadline_594210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the ack deadline for a specific message. This method is useful
  ## to indicate that more time is needed to process a message by the
  ## subscriber, or to make the message available for redelivery if the
  ## processing was interrupted. Note that this does not modify the
  ## subscription-level `ackDeadlineSeconds` used for subsequent messages.
  ## 
  let valid = call_594226.validator(path, query, header, formData, body)
  let scheme = call_594226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594226.url(scheme.get, call_594226.host, call_594226.base,
                         call_594226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594226, url, valid)

proc call*(call_594227: Call_PubsubProjectsSubscriptionsModifyAckDeadline_594210;
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
  var path_594228 = newJObject()
  var query_594229 = newJObject()
  var body_594230 = newJObject()
  add(query_594229, "upload_protocol", newJString(uploadProtocol))
  add(query_594229, "fields", newJString(fields))
  add(query_594229, "quotaUser", newJString(quotaUser))
  add(path_594228, "subscription", newJString(subscription))
  add(query_594229, "alt", newJString(alt))
  add(query_594229, "oauth_token", newJString(oauthToken))
  add(query_594229, "callback", newJString(callback))
  add(query_594229, "access_token", newJString(accessToken))
  add(query_594229, "uploadType", newJString(uploadType))
  add(query_594229, "key", newJString(key))
  add(query_594229, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594230 = body
  add(query_594229, "prettyPrint", newJBool(prettyPrint))
  result = call_594227.call(path_594228, query_594229, nil, nil, body_594230)

var pubsubProjectsSubscriptionsModifyAckDeadline* = Call_PubsubProjectsSubscriptionsModifyAckDeadline_594210(
    name: "pubsubProjectsSubscriptionsModifyAckDeadline",
    meth: HttpMethod.HttpPost, host: "pubsub.googleapis.com",
    route: "/v1/{subscription}:modifyAckDeadline",
    validator: validate_PubsubProjectsSubscriptionsModifyAckDeadline_594211,
    base: "/", url: url_PubsubProjectsSubscriptionsModifyAckDeadline_594212,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsModifyPushConfig_594231 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsSubscriptionsModifyPushConfig_594233(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PubsubProjectsSubscriptionsModifyPushConfig_594232(path: JsonNode;
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
  var valid_594234 = path.getOrDefault("subscription")
  valid_594234 = validateParameter(valid_594234, JString, required = true,
                                 default = nil)
  if valid_594234 != nil:
    section.add "subscription", valid_594234
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
  var valid_594235 = query.getOrDefault("upload_protocol")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "upload_protocol", valid_594235
  var valid_594236 = query.getOrDefault("fields")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "fields", valid_594236
  var valid_594237 = query.getOrDefault("quotaUser")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "quotaUser", valid_594237
  var valid_594238 = query.getOrDefault("alt")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = newJString("json"))
  if valid_594238 != nil:
    section.add "alt", valid_594238
  var valid_594239 = query.getOrDefault("oauth_token")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "oauth_token", valid_594239
  var valid_594240 = query.getOrDefault("callback")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "callback", valid_594240
  var valid_594241 = query.getOrDefault("access_token")
  valid_594241 = validateParameter(valid_594241, JString, required = false,
                                 default = nil)
  if valid_594241 != nil:
    section.add "access_token", valid_594241
  var valid_594242 = query.getOrDefault("uploadType")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "uploadType", valid_594242
  var valid_594243 = query.getOrDefault("key")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "key", valid_594243
  var valid_594244 = query.getOrDefault("$.xgafv")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = newJString("1"))
  if valid_594244 != nil:
    section.add "$.xgafv", valid_594244
  var valid_594245 = query.getOrDefault("prettyPrint")
  valid_594245 = validateParameter(valid_594245, JBool, required = false,
                                 default = newJBool(true))
  if valid_594245 != nil:
    section.add "prettyPrint", valid_594245
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

proc call*(call_594247: Call_PubsubProjectsSubscriptionsModifyPushConfig_594231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the `PushConfig` for a specified subscription.
  ## 
  ## This may be used to change a push subscription to a pull one (signified by
  ## an empty `PushConfig`) or vice versa, or change the endpoint URL and other
  ## attributes of a push subscription. Messages will accumulate for delivery
  ## continuously through the call regardless of changes to the `PushConfig`.
  ## 
  let valid = call_594247.validator(path, query, header, formData, body)
  let scheme = call_594247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594247.url(scheme.get, call_594247.host, call_594247.base,
                         call_594247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594247, url, valid)

proc call*(call_594248: Call_PubsubProjectsSubscriptionsModifyPushConfig_594231;
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
  var path_594249 = newJObject()
  var query_594250 = newJObject()
  var body_594251 = newJObject()
  add(query_594250, "upload_protocol", newJString(uploadProtocol))
  add(query_594250, "fields", newJString(fields))
  add(query_594250, "quotaUser", newJString(quotaUser))
  add(path_594249, "subscription", newJString(subscription))
  add(query_594250, "alt", newJString(alt))
  add(query_594250, "oauth_token", newJString(oauthToken))
  add(query_594250, "callback", newJString(callback))
  add(query_594250, "access_token", newJString(accessToken))
  add(query_594250, "uploadType", newJString(uploadType))
  add(query_594250, "key", newJString(key))
  add(query_594250, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594251 = body
  add(query_594250, "prettyPrint", newJBool(prettyPrint))
  result = call_594248.call(path_594249, query_594250, nil, nil, body_594251)

var pubsubProjectsSubscriptionsModifyPushConfig* = Call_PubsubProjectsSubscriptionsModifyPushConfig_594231(
    name: "pubsubProjectsSubscriptionsModifyPushConfig",
    meth: HttpMethod.HttpPost, host: "pubsub.googleapis.com",
    route: "/v1/{subscription}:modifyPushConfig",
    validator: validate_PubsubProjectsSubscriptionsModifyPushConfig_594232,
    base: "/", url: url_PubsubProjectsSubscriptionsModifyPushConfig_594233,
    schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsPull_594252 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsSubscriptionsPull_594254(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PubsubProjectsSubscriptionsPull_594253(path: JsonNode;
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
  var valid_594255 = path.getOrDefault("subscription")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "subscription", valid_594255
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
  var valid_594256 = query.getOrDefault("upload_protocol")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "upload_protocol", valid_594256
  var valid_594257 = query.getOrDefault("fields")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "fields", valid_594257
  var valid_594258 = query.getOrDefault("quotaUser")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "quotaUser", valid_594258
  var valid_594259 = query.getOrDefault("alt")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = newJString("json"))
  if valid_594259 != nil:
    section.add "alt", valid_594259
  var valid_594260 = query.getOrDefault("oauth_token")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "oauth_token", valid_594260
  var valid_594261 = query.getOrDefault("callback")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "callback", valid_594261
  var valid_594262 = query.getOrDefault("access_token")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "access_token", valid_594262
  var valid_594263 = query.getOrDefault("uploadType")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "uploadType", valid_594263
  var valid_594264 = query.getOrDefault("key")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "key", valid_594264
  var valid_594265 = query.getOrDefault("$.xgafv")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = newJString("1"))
  if valid_594265 != nil:
    section.add "$.xgafv", valid_594265
  var valid_594266 = query.getOrDefault("prettyPrint")
  valid_594266 = validateParameter(valid_594266, JBool, required = false,
                                 default = newJBool(true))
  if valid_594266 != nil:
    section.add "prettyPrint", valid_594266
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

proc call*(call_594268: Call_PubsubProjectsSubscriptionsPull_594252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pulls messages from the server. The server may return `UNAVAILABLE` if
  ## there are too many concurrent pull requests pending for the given
  ## subscription.
  ## 
  let valid = call_594268.validator(path, query, header, formData, body)
  let scheme = call_594268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594268.url(scheme.get, call_594268.host, call_594268.base,
                         call_594268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594268, url, valid)

proc call*(call_594269: Call_PubsubProjectsSubscriptionsPull_594252;
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
  var path_594270 = newJObject()
  var query_594271 = newJObject()
  var body_594272 = newJObject()
  add(query_594271, "upload_protocol", newJString(uploadProtocol))
  add(query_594271, "fields", newJString(fields))
  add(query_594271, "quotaUser", newJString(quotaUser))
  add(path_594270, "subscription", newJString(subscription))
  add(query_594271, "alt", newJString(alt))
  add(query_594271, "oauth_token", newJString(oauthToken))
  add(query_594271, "callback", newJString(callback))
  add(query_594271, "access_token", newJString(accessToken))
  add(query_594271, "uploadType", newJString(uploadType))
  add(query_594271, "key", newJString(key))
  add(query_594271, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594272 = body
  add(query_594271, "prettyPrint", newJBool(prettyPrint))
  result = call_594269.call(path_594270, query_594271, nil, nil, body_594272)

var pubsubProjectsSubscriptionsPull* = Call_PubsubProjectsSubscriptionsPull_594252(
    name: "pubsubProjectsSubscriptionsPull", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{subscription}:pull",
    validator: validate_PubsubProjectsSubscriptionsPull_594253, base: "/",
    url: url_PubsubProjectsSubscriptionsPull_594254, schemes: {Scheme.Https})
type
  Call_PubsubProjectsSubscriptionsSeek_594273 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsSubscriptionsSeek_594275(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PubsubProjectsSubscriptionsSeek_594274(path: JsonNode;
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
  var valid_594276 = path.getOrDefault("subscription")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "subscription", valid_594276
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
  var valid_594277 = query.getOrDefault("upload_protocol")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "upload_protocol", valid_594277
  var valid_594278 = query.getOrDefault("fields")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "fields", valid_594278
  var valid_594279 = query.getOrDefault("quotaUser")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "quotaUser", valid_594279
  var valid_594280 = query.getOrDefault("alt")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = newJString("json"))
  if valid_594280 != nil:
    section.add "alt", valid_594280
  var valid_594281 = query.getOrDefault("oauth_token")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "oauth_token", valid_594281
  var valid_594282 = query.getOrDefault("callback")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "callback", valid_594282
  var valid_594283 = query.getOrDefault("access_token")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = nil)
  if valid_594283 != nil:
    section.add "access_token", valid_594283
  var valid_594284 = query.getOrDefault("uploadType")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "uploadType", valid_594284
  var valid_594285 = query.getOrDefault("key")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = nil)
  if valid_594285 != nil:
    section.add "key", valid_594285
  var valid_594286 = query.getOrDefault("$.xgafv")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = newJString("1"))
  if valid_594286 != nil:
    section.add "$.xgafv", valid_594286
  var valid_594287 = query.getOrDefault("prettyPrint")
  valid_594287 = validateParameter(valid_594287, JBool, required = false,
                                 default = newJBool(true))
  if valid_594287 != nil:
    section.add "prettyPrint", valid_594287
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

proc call*(call_594289: Call_PubsubProjectsSubscriptionsSeek_594273;
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
  let valid = call_594289.validator(path, query, header, formData, body)
  let scheme = call_594289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594289.url(scheme.get, call_594289.host, call_594289.base,
                         call_594289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594289, url, valid)

proc call*(call_594290: Call_PubsubProjectsSubscriptionsSeek_594273;
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
  var path_594291 = newJObject()
  var query_594292 = newJObject()
  var body_594293 = newJObject()
  add(query_594292, "upload_protocol", newJString(uploadProtocol))
  add(query_594292, "fields", newJString(fields))
  add(query_594292, "quotaUser", newJString(quotaUser))
  add(path_594291, "subscription", newJString(subscription))
  add(query_594292, "alt", newJString(alt))
  add(query_594292, "oauth_token", newJString(oauthToken))
  add(query_594292, "callback", newJString(callback))
  add(query_594292, "access_token", newJString(accessToken))
  add(query_594292, "uploadType", newJString(uploadType))
  add(query_594292, "key", newJString(key))
  add(query_594292, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594293 = body
  add(query_594292, "prettyPrint", newJBool(prettyPrint))
  result = call_594290.call(path_594291, query_594292, nil, nil, body_594293)

var pubsubProjectsSubscriptionsSeek* = Call_PubsubProjectsSubscriptionsSeek_594273(
    name: "pubsubProjectsSubscriptionsSeek", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{subscription}:seek",
    validator: validate_PubsubProjectsSubscriptionsSeek_594274, base: "/",
    url: url_PubsubProjectsSubscriptionsSeek_594275, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsGet_594294 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsTopicsGet_594296(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "topic")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsGet_594295(path: JsonNode; query: JsonNode;
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
  var valid_594297 = path.getOrDefault("topic")
  valid_594297 = validateParameter(valid_594297, JString, required = true,
                                 default = nil)
  if valid_594297 != nil:
    section.add "topic", valid_594297
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
  var valid_594298 = query.getOrDefault("upload_protocol")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "upload_protocol", valid_594298
  var valid_594299 = query.getOrDefault("fields")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "fields", valid_594299
  var valid_594300 = query.getOrDefault("quotaUser")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "quotaUser", valid_594300
  var valid_594301 = query.getOrDefault("alt")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = newJString("json"))
  if valid_594301 != nil:
    section.add "alt", valid_594301
  var valid_594302 = query.getOrDefault("oauth_token")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = nil)
  if valid_594302 != nil:
    section.add "oauth_token", valid_594302
  var valid_594303 = query.getOrDefault("callback")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = nil)
  if valid_594303 != nil:
    section.add "callback", valid_594303
  var valid_594304 = query.getOrDefault("access_token")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = nil)
  if valid_594304 != nil:
    section.add "access_token", valid_594304
  var valid_594305 = query.getOrDefault("uploadType")
  valid_594305 = validateParameter(valid_594305, JString, required = false,
                                 default = nil)
  if valid_594305 != nil:
    section.add "uploadType", valid_594305
  var valid_594306 = query.getOrDefault("key")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "key", valid_594306
  var valid_594307 = query.getOrDefault("$.xgafv")
  valid_594307 = validateParameter(valid_594307, JString, required = false,
                                 default = newJString("1"))
  if valid_594307 != nil:
    section.add "$.xgafv", valid_594307
  var valid_594308 = query.getOrDefault("prettyPrint")
  valid_594308 = validateParameter(valid_594308, JBool, required = false,
                                 default = newJBool(true))
  if valid_594308 != nil:
    section.add "prettyPrint", valid_594308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594309: Call_PubsubProjectsTopicsGet_594294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration of a topic.
  ## 
  let valid = call_594309.validator(path, query, header, formData, body)
  let scheme = call_594309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594309.url(scheme.get, call_594309.host, call_594309.base,
                         call_594309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594309, url, valid)

proc call*(call_594310: Call_PubsubProjectsTopicsGet_594294; topic: string;
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
  var path_594311 = newJObject()
  var query_594312 = newJObject()
  add(query_594312, "upload_protocol", newJString(uploadProtocol))
  add(query_594312, "fields", newJString(fields))
  add(query_594312, "quotaUser", newJString(quotaUser))
  add(query_594312, "alt", newJString(alt))
  add(query_594312, "oauth_token", newJString(oauthToken))
  add(query_594312, "callback", newJString(callback))
  add(query_594312, "access_token", newJString(accessToken))
  add(query_594312, "uploadType", newJString(uploadType))
  add(query_594312, "key", newJString(key))
  add(path_594311, "topic", newJString(topic))
  add(query_594312, "$.xgafv", newJString(Xgafv))
  add(query_594312, "prettyPrint", newJBool(prettyPrint))
  result = call_594310.call(path_594311, query_594312, nil, nil, nil)

var pubsubProjectsTopicsGet* = Call_PubsubProjectsTopicsGet_594294(
    name: "pubsubProjectsTopicsGet", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{topic}",
    validator: validate_PubsubProjectsTopicsGet_594295, base: "/",
    url: url_PubsubProjectsTopicsGet_594296, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsDelete_594313 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsTopicsDelete_594315(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "topic")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubProjectsTopicsDelete_594314(path: JsonNode; query: JsonNode;
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
  var valid_594316 = path.getOrDefault("topic")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "topic", valid_594316
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
  var valid_594317 = query.getOrDefault("upload_protocol")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = nil)
  if valid_594317 != nil:
    section.add "upload_protocol", valid_594317
  var valid_594318 = query.getOrDefault("fields")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "fields", valid_594318
  var valid_594319 = query.getOrDefault("quotaUser")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = nil)
  if valid_594319 != nil:
    section.add "quotaUser", valid_594319
  var valid_594320 = query.getOrDefault("alt")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = newJString("json"))
  if valid_594320 != nil:
    section.add "alt", valid_594320
  var valid_594321 = query.getOrDefault("oauth_token")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = nil)
  if valid_594321 != nil:
    section.add "oauth_token", valid_594321
  var valid_594322 = query.getOrDefault("callback")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = nil)
  if valid_594322 != nil:
    section.add "callback", valid_594322
  var valid_594323 = query.getOrDefault("access_token")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = nil)
  if valid_594323 != nil:
    section.add "access_token", valid_594323
  var valid_594324 = query.getOrDefault("uploadType")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = nil)
  if valid_594324 != nil:
    section.add "uploadType", valid_594324
  var valid_594325 = query.getOrDefault("key")
  valid_594325 = validateParameter(valid_594325, JString, required = false,
                                 default = nil)
  if valid_594325 != nil:
    section.add "key", valid_594325
  var valid_594326 = query.getOrDefault("$.xgafv")
  valid_594326 = validateParameter(valid_594326, JString, required = false,
                                 default = newJString("1"))
  if valid_594326 != nil:
    section.add "$.xgafv", valid_594326
  var valid_594327 = query.getOrDefault("prettyPrint")
  valid_594327 = validateParameter(valid_594327, JBool, required = false,
                                 default = newJBool(true))
  if valid_594327 != nil:
    section.add "prettyPrint", valid_594327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594328: Call_PubsubProjectsTopicsDelete_594313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the topic with the given name. Returns `NOT_FOUND` if the topic
  ## does not exist. After a topic is deleted, a new topic may be created with
  ## the same name; this is an entirely new topic with none of the old
  ## configuration or subscriptions. Existing subscriptions to this topic are
  ## not deleted, but their `topic` field is set to `_deleted-topic_`.
  ## 
  let valid = call_594328.validator(path, query, header, formData, body)
  let scheme = call_594328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594328.url(scheme.get, call_594328.host, call_594328.base,
                         call_594328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594328, url, valid)

proc call*(call_594329: Call_PubsubProjectsTopicsDelete_594313; topic: string;
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
  var path_594330 = newJObject()
  var query_594331 = newJObject()
  add(query_594331, "upload_protocol", newJString(uploadProtocol))
  add(query_594331, "fields", newJString(fields))
  add(query_594331, "quotaUser", newJString(quotaUser))
  add(query_594331, "alt", newJString(alt))
  add(query_594331, "oauth_token", newJString(oauthToken))
  add(query_594331, "callback", newJString(callback))
  add(query_594331, "access_token", newJString(accessToken))
  add(query_594331, "uploadType", newJString(uploadType))
  add(query_594331, "key", newJString(key))
  add(path_594330, "topic", newJString(topic))
  add(query_594331, "$.xgafv", newJString(Xgafv))
  add(query_594331, "prettyPrint", newJBool(prettyPrint))
  result = call_594329.call(path_594330, query_594331, nil, nil, nil)

var pubsubProjectsTopicsDelete* = Call_PubsubProjectsTopicsDelete_594313(
    name: "pubsubProjectsTopicsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com", route: "/v1/{topic}",
    validator: validate_PubsubProjectsTopicsDelete_594314, base: "/",
    url: url_PubsubProjectsTopicsDelete_594315, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsSnapshotsList_594332 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsTopicsSnapshotsList_594334(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PubsubProjectsTopicsSnapshotsList_594333(path: JsonNode;
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
  var valid_594335 = path.getOrDefault("topic")
  valid_594335 = validateParameter(valid_594335, JString, required = true,
                                 default = nil)
  if valid_594335 != nil:
    section.add "topic", valid_594335
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
  var valid_594336 = query.getOrDefault("upload_protocol")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "upload_protocol", valid_594336
  var valid_594337 = query.getOrDefault("fields")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "fields", valid_594337
  var valid_594338 = query.getOrDefault("pageToken")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "pageToken", valid_594338
  var valid_594339 = query.getOrDefault("quotaUser")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "quotaUser", valid_594339
  var valid_594340 = query.getOrDefault("alt")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = newJString("json"))
  if valid_594340 != nil:
    section.add "alt", valid_594340
  var valid_594341 = query.getOrDefault("oauth_token")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = nil)
  if valid_594341 != nil:
    section.add "oauth_token", valid_594341
  var valid_594342 = query.getOrDefault("callback")
  valid_594342 = validateParameter(valid_594342, JString, required = false,
                                 default = nil)
  if valid_594342 != nil:
    section.add "callback", valid_594342
  var valid_594343 = query.getOrDefault("access_token")
  valid_594343 = validateParameter(valid_594343, JString, required = false,
                                 default = nil)
  if valid_594343 != nil:
    section.add "access_token", valid_594343
  var valid_594344 = query.getOrDefault("uploadType")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = nil)
  if valid_594344 != nil:
    section.add "uploadType", valid_594344
  var valid_594345 = query.getOrDefault("key")
  valid_594345 = validateParameter(valid_594345, JString, required = false,
                                 default = nil)
  if valid_594345 != nil:
    section.add "key", valid_594345
  var valid_594346 = query.getOrDefault("$.xgafv")
  valid_594346 = validateParameter(valid_594346, JString, required = false,
                                 default = newJString("1"))
  if valid_594346 != nil:
    section.add "$.xgafv", valid_594346
  var valid_594347 = query.getOrDefault("pageSize")
  valid_594347 = validateParameter(valid_594347, JInt, required = false, default = nil)
  if valid_594347 != nil:
    section.add "pageSize", valid_594347
  var valid_594348 = query.getOrDefault("prettyPrint")
  valid_594348 = validateParameter(valid_594348, JBool, required = false,
                                 default = newJBool(true))
  if valid_594348 != nil:
    section.add "prettyPrint", valid_594348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594349: Call_PubsubProjectsTopicsSnapshotsList_594332;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the names of the snapshots on this topic. Snapshots are used in
  ## <a href="https://cloud.google.com/pubsub/docs/replay-overview">Seek</a>
  ## operations, which allow
  ## you to manage message acknowledgments in bulk. That is, you can set the
  ## acknowledgment state of messages in an existing subscription to the state
  ## captured by a snapshot.
  ## 
  let valid = call_594349.validator(path, query, header, formData, body)
  let scheme = call_594349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594349.url(scheme.get, call_594349.host, call_594349.base,
                         call_594349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594349, url, valid)

proc call*(call_594350: Call_PubsubProjectsTopicsSnapshotsList_594332;
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
  var path_594351 = newJObject()
  var query_594352 = newJObject()
  add(query_594352, "upload_protocol", newJString(uploadProtocol))
  add(query_594352, "fields", newJString(fields))
  add(query_594352, "pageToken", newJString(pageToken))
  add(query_594352, "quotaUser", newJString(quotaUser))
  add(query_594352, "alt", newJString(alt))
  add(query_594352, "oauth_token", newJString(oauthToken))
  add(query_594352, "callback", newJString(callback))
  add(query_594352, "access_token", newJString(accessToken))
  add(query_594352, "uploadType", newJString(uploadType))
  add(query_594352, "key", newJString(key))
  add(path_594351, "topic", newJString(topic))
  add(query_594352, "$.xgafv", newJString(Xgafv))
  add(query_594352, "pageSize", newJInt(pageSize))
  add(query_594352, "prettyPrint", newJBool(prettyPrint))
  result = call_594350.call(path_594351, query_594352, nil, nil, nil)

var pubsubProjectsTopicsSnapshotsList* = Call_PubsubProjectsTopicsSnapshotsList_594332(
    name: "pubsubProjectsTopicsSnapshotsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{topic}/snapshots",
    validator: validate_PubsubProjectsTopicsSnapshotsList_594333, base: "/",
    url: url_PubsubProjectsTopicsSnapshotsList_594334, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsSubscriptionsList_594353 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsTopicsSubscriptionsList_594355(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PubsubProjectsTopicsSubscriptionsList_594354(path: JsonNode;
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
  var valid_594356 = path.getOrDefault("topic")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "topic", valid_594356
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
  var valid_594357 = query.getOrDefault("upload_protocol")
  valid_594357 = validateParameter(valid_594357, JString, required = false,
                                 default = nil)
  if valid_594357 != nil:
    section.add "upload_protocol", valid_594357
  var valid_594358 = query.getOrDefault("fields")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = nil)
  if valid_594358 != nil:
    section.add "fields", valid_594358
  var valid_594359 = query.getOrDefault("pageToken")
  valid_594359 = validateParameter(valid_594359, JString, required = false,
                                 default = nil)
  if valid_594359 != nil:
    section.add "pageToken", valid_594359
  var valid_594360 = query.getOrDefault("quotaUser")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = nil)
  if valid_594360 != nil:
    section.add "quotaUser", valid_594360
  var valid_594361 = query.getOrDefault("alt")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = newJString("json"))
  if valid_594361 != nil:
    section.add "alt", valid_594361
  var valid_594362 = query.getOrDefault("oauth_token")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = nil)
  if valid_594362 != nil:
    section.add "oauth_token", valid_594362
  var valid_594363 = query.getOrDefault("callback")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = nil)
  if valid_594363 != nil:
    section.add "callback", valid_594363
  var valid_594364 = query.getOrDefault("access_token")
  valid_594364 = validateParameter(valid_594364, JString, required = false,
                                 default = nil)
  if valid_594364 != nil:
    section.add "access_token", valid_594364
  var valid_594365 = query.getOrDefault("uploadType")
  valid_594365 = validateParameter(valid_594365, JString, required = false,
                                 default = nil)
  if valid_594365 != nil:
    section.add "uploadType", valid_594365
  var valid_594366 = query.getOrDefault("key")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = nil)
  if valid_594366 != nil:
    section.add "key", valid_594366
  var valid_594367 = query.getOrDefault("$.xgafv")
  valid_594367 = validateParameter(valid_594367, JString, required = false,
                                 default = newJString("1"))
  if valid_594367 != nil:
    section.add "$.xgafv", valid_594367
  var valid_594368 = query.getOrDefault("pageSize")
  valid_594368 = validateParameter(valid_594368, JInt, required = false, default = nil)
  if valid_594368 != nil:
    section.add "pageSize", valid_594368
  var valid_594369 = query.getOrDefault("prettyPrint")
  valid_594369 = validateParameter(valid_594369, JBool, required = false,
                                 default = newJBool(true))
  if valid_594369 != nil:
    section.add "prettyPrint", valid_594369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594370: Call_PubsubProjectsTopicsSubscriptionsList_594353;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the names of the subscriptions on this topic.
  ## 
  let valid = call_594370.validator(path, query, header, formData, body)
  let scheme = call_594370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594370.url(scheme.get, call_594370.host, call_594370.base,
                         call_594370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594370, url, valid)

proc call*(call_594371: Call_PubsubProjectsTopicsSubscriptionsList_594353;
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
  var path_594372 = newJObject()
  var query_594373 = newJObject()
  add(query_594373, "upload_protocol", newJString(uploadProtocol))
  add(query_594373, "fields", newJString(fields))
  add(query_594373, "pageToken", newJString(pageToken))
  add(query_594373, "quotaUser", newJString(quotaUser))
  add(query_594373, "alt", newJString(alt))
  add(query_594373, "oauth_token", newJString(oauthToken))
  add(query_594373, "callback", newJString(callback))
  add(query_594373, "access_token", newJString(accessToken))
  add(query_594373, "uploadType", newJString(uploadType))
  add(query_594373, "key", newJString(key))
  add(path_594372, "topic", newJString(topic))
  add(query_594373, "$.xgafv", newJString(Xgafv))
  add(query_594373, "pageSize", newJInt(pageSize))
  add(query_594373, "prettyPrint", newJBool(prettyPrint))
  result = call_594371.call(path_594372, query_594373, nil, nil, nil)

var pubsubProjectsTopicsSubscriptionsList* = Call_PubsubProjectsTopicsSubscriptionsList_594353(
    name: "pubsubProjectsTopicsSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1/{topic}/subscriptions",
    validator: validate_PubsubProjectsTopicsSubscriptionsList_594354, base: "/",
    url: url_PubsubProjectsTopicsSubscriptionsList_594355, schemes: {Scheme.Https})
type
  Call_PubsubProjectsTopicsPublish_594374 = ref object of OpenApiRestCall_593408
proc url_PubsubProjectsTopicsPublish_594376(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PubsubProjectsTopicsPublish_594375(path: JsonNode; query: JsonNode;
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
  var valid_594377 = path.getOrDefault("topic")
  valid_594377 = validateParameter(valid_594377, JString, required = true,
                                 default = nil)
  if valid_594377 != nil:
    section.add "topic", valid_594377
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
  var valid_594378 = query.getOrDefault("upload_protocol")
  valid_594378 = validateParameter(valid_594378, JString, required = false,
                                 default = nil)
  if valid_594378 != nil:
    section.add "upload_protocol", valid_594378
  var valid_594379 = query.getOrDefault("fields")
  valid_594379 = validateParameter(valid_594379, JString, required = false,
                                 default = nil)
  if valid_594379 != nil:
    section.add "fields", valid_594379
  var valid_594380 = query.getOrDefault("quotaUser")
  valid_594380 = validateParameter(valid_594380, JString, required = false,
                                 default = nil)
  if valid_594380 != nil:
    section.add "quotaUser", valid_594380
  var valid_594381 = query.getOrDefault("alt")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = newJString("json"))
  if valid_594381 != nil:
    section.add "alt", valid_594381
  var valid_594382 = query.getOrDefault("oauth_token")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = nil)
  if valid_594382 != nil:
    section.add "oauth_token", valid_594382
  var valid_594383 = query.getOrDefault("callback")
  valid_594383 = validateParameter(valid_594383, JString, required = false,
                                 default = nil)
  if valid_594383 != nil:
    section.add "callback", valid_594383
  var valid_594384 = query.getOrDefault("access_token")
  valid_594384 = validateParameter(valid_594384, JString, required = false,
                                 default = nil)
  if valid_594384 != nil:
    section.add "access_token", valid_594384
  var valid_594385 = query.getOrDefault("uploadType")
  valid_594385 = validateParameter(valid_594385, JString, required = false,
                                 default = nil)
  if valid_594385 != nil:
    section.add "uploadType", valid_594385
  var valid_594386 = query.getOrDefault("key")
  valid_594386 = validateParameter(valid_594386, JString, required = false,
                                 default = nil)
  if valid_594386 != nil:
    section.add "key", valid_594386
  var valid_594387 = query.getOrDefault("$.xgafv")
  valid_594387 = validateParameter(valid_594387, JString, required = false,
                                 default = newJString("1"))
  if valid_594387 != nil:
    section.add "$.xgafv", valid_594387
  var valid_594388 = query.getOrDefault("prettyPrint")
  valid_594388 = validateParameter(valid_594388, JBool, required = false,
                                 default = newJBool(true))
  if valid_594388 != nil:
    section.add "prettyPrint", valid_594388
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

proc call*(call_594390: Call_PubsubProjectsTopicsPublish_594374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds one or more messages to the topic. Returns `NOT_FOUND` if the topic
  ## does not exist.
  ## 
  let valid = call_594390.validator(path, query, header, formData, body)
  let scheme = call_594390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594390.url(scheme.get, call_594390.host, call_594390.base,
                         call_594390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594390, url, valid)

proc call*(call_594391: Call_PubsubProjectsTopicsPublish_594374; topic: string;
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
  var path_594392 = newJObject()
  var query_594393 = newJObject()
  var body_594394 = newJObject()
  add(query_594393, "upload_protocol", newJString(uploadProtocol))
  add(query_594393, "fields", newJString(fields))
  add(query_594393, "quotaUser", newJString(quotaUser))
  add(query_594393, "alt", newJString(alt))
  add(query_594393, "oauth_token", newJString(oauthToken))
  add(query_594393, "callback", newJString(callback))
  add(query_594393, "access_token", newJString(accessToken))
  add(query_594393, "uploadType", newJString(uploadType))
  add(query_594393, "key", newJString(key))
  add(path_594392, "topic", newJString(topic))
  add(query_594393, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594394 = body
  add(query_594393, "prettyPrint", newJBool(prettyPrint))
  result = call_594391.call(path_594392, query_594393, nil, nil, body_594394)

var pubsubProjectsTopicsPublish* = Call_PubsubProjectsTopicsPublish_594374(
    name: "pubsubProjectsTopicsPublish", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1/{topic}:publish",
    validator: validate_PubsubProjectsTopicsPublish_594375, base: "/",
    url: url_PubsubProjectsTopicsPublish_594376, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
